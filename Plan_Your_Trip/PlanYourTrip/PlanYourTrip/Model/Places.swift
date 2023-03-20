//
//  Places.swift
//  PlanYourTrip
//
//  Created by Wisly Juganda on 3/1/23.
//
import Foundation
import CoreLocation
import MapKit
import SwiftUI

// MARK: Data Models
struct PlaceSearchPayload: Decodable {
    let results: [Place]
}
struct Place: Codable, Identifiable, Equatable {
    /*
     Represents a place document returned by the Google Places API
     */
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.name == rhs.name
    }
    
    var place_id: String
    var id: String { place_id }
    var geometry: Geometry?
    var name: String?
    var price_level: Int?
    var rating: Double?
    var types: [String]?
    var photos: [Photo]?
    var city: String = ""
    var photo: String? { name?.convertedToSlug() }
    
    init(place_id: String, geometry: Geometry, name: String, price_level: Int?, rating: Double, types: [String], photos: [Photo]) {
        self.place_id = place_id
        self.name = name
        self.geometry = geometry
        self.rating = rating
        self.types = types
        self.photos = photos
        self.price_level = (price_level==nil) ? 0 as Int : price_level!
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.place_id = try container.decode(String.self, forKey: .place_id)
        
        let name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.name = name
        
        let geometry = try container.decodeIfPresent(Geometry.self, forKey: .geometry) ?? nil
        self.geometry = geometry
        
        let rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        self.rating = rating
        
        let types = try container.decodeIfPresent([String].self, forKey: .types) ?? []
        self.types = types
        
        let photos = try container.decodeIfPresent([Photo].self, forKey: .photos) ?? [Photo(photo_reference: "")]
        self.photos = photos
        
        let price_level = try container.decodeIfPresent(Int.self, forKey: .price_level) ?? 0
        self.price_level = price_level
    }
}

struct Geometry: Codable {
    let location: LocationDoc
}

struct Photo: Codable {
    let photo_reference: String
}

struct LocationDoc: Codable {
    let lat: Double
    let lng: Double
}

class placesListHolder: NSObject {
    let placesList: [Place]
    init(placesList: [Place]) {
        self.placesList = placesList
    }
}

// MARK: Get Places API Data
class PlacesClient: ObservableObject {
    let key = "AIzaSyBDFpfrPkQ855cFX0IidBu8sYytpT8588I"
    
    let searchCache = NSCache<NSString, placesListHolder>()
    let hotelsCache = NSCache<NSString, placesListHolder>()
    let restaurantsCache = NSCache<NSString, placesListHolder>()
    
    @Published var places: [Place] = []
    @Published var hotels: [Place] = []
    @Published var restaurants: [Place] = []
    
    @Published var hotelsLoaded = false
    @Published var restaurantsLoaded = false
    
    var searchHistory: [String] = []
    @Published var searchedPlaces: [String: Place] = [:]
    
    
    // Attribution: https://praveenkommuri.medium.com/how-to-read-parse-local-json-file-in-swift-28f6cec747cf
    init() {
        // MARK: Initialize User Preferences
        if let storedDate = UserDefaults.standard.object(forKey: "initialLaunch") as? Date {
            print("Stored Date: ", storedDate)
        } else {
            print("Setting initial launch date to ", Date())
            UserDefaults.standard.set(Date(), forKey: "initialLaunch")
            UserDefaults.standard.set("Manaswini Aitha, Wisly Juganda", forKey: "developerName")
            UserDefaults.standard.set("1.0.0", forKey: "version")
        }
        Task {
            await self.getPlaces(city: "Chicago")
        }
    }

    // MARK: Get Places
    //
    public func reload(city: String) {
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=tourist%20attractions%20in%20\(city)&key=\(self.key)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
                print(response ?? "")
                print("error")
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                     }
            do {
                let decoder = JSONDecoder()
                // TODO: Convert to camelCase
                let placesPayload = try decoder.decode(PlaceSearchPayload.self, from: data)
                DispatchQueue.main.async {
                    self.places = placesPayload.results
                    print(self.places)
                }
            } catch {
                print("error: \(error)")
            }
        }
        task.resume()
    }
    
    // MARK: Async get Places
    /*
     Asynchronously sets self.places from array of Place objects as requested from Google Places API
     */
    func getPlaces(city: String) async {
        if let placesListHolder = searchCache.object(forKey: NSString(string: city)) {
            self.places = placesListHolder.placesList
            return
        }
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=tourist%20attractions%20in%20\(city)&key=\(self.key)")!
        let urlSession = URLSession.shared
        do {
            let (data, _) = try await urlSession.data(from: url)
            let placesPayload = try JSONDecoder().decode(PlaceSearchPayload.self, from: data)
            self.searchCache.setObject(placesListHolder(placesList: placesPayload.results), forKey: NSString(string: city))
            DispatchQueue.main.async {
                self.places = placesPayload.results
                print(self.places)
            }
        }
        catch {
            debugPrint("Error loading: \(String(describing: error))")
        }
    }
    
    // MARK: Get async nearby hotels
    func getHotels(placeName: String, lat: Float, lng: Float, completion: @escaping ([Place]?, Error?) -> Void) {
            let url =  URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=hotel&location=\(lat)%2C\(lng)&radius=1500&type=lodging&key=\(self.key)")!
            let task =  URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                  // If we are missing data, send back no data with an error
                  DispatchQueue.main.async { completion(nil, error) }
                  return
                }
                do {
                    let decoder = JSONDecoder()
                    let placesPayload = try decoder.decode(PlaceSearchPayload.self, from: data)
                    DispatchQueue.main.async {
                        print(placesPayload.results)
                        self.hotelsLoaded = true
                        self.hotels = placesPayload.results
                        self.hotelsCache.setObject(placesListHolder(placesList: placesPayload.results), forKey: NSString(string: placeName))
                        completion(placesPayload.results, nil)
                            
                    }
                }
                catch (let parsingError) {
                    DispatchQueue.main.async { completion(nil, parsingError) }
                }
            }
            task.resume()
            
        }
    
    // MARK: Get async nearby restaurants
    func getRestaurants(placeName: String, lat: Float, lng: Float, completion: @escaping ([Place]?, Error?) -> Void) {
            let url =  URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=restaurant&location=\(lat)%2C\(lng)&radius=1500&type=restaurant&key=\(self.key)")!
            let task =  URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                  // If we are missing data, send back no data with an error
                  DispatchQueue.main.async { completion(nil, error) }
                  return
                }

                do {
                    let decoder = JSONDecoder()
                    let placesPayload = try decoder.decode(PlaceSearchPayload.self, from: data)
                    DispatchQueue.main.async {
                        print(placesPayload.results)
                        self.restaurantsLoaded = true
                        self.restaurants = placesPayload.results
                        self.restaurantsCache.setObject(placesListHolder(placesList: placesPayload.results), forKey: NSString(string: placeName))
                        completion(placesPayload.results, nil)
                            
                    }
                }
                catch (let parsingError) {
                    DispatchQueue.main.async { completion(nil, parsingError) }
                }
                
            }
            task.resume()
            
        }
}


