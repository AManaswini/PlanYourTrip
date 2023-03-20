//
//  Data Manager.swift
//  PlanYourTrip
//
//  Created by Manaswini Aitha on 2/25/23.
//

import Foundation

class Model: ObservableObject {
    @Published var shouldReloadView = false
}

public class DataManager {
    public static let sharedInstance = DataManager()
    let defaults = UserDefaults.standard
    var sortedPlaces: [Place] = []
    
    /// saves favourited place into user defaults named favourites
    func saveFavorites(_ name:String) {
        var favList:[String] = defaults.object(forKey: "favourites") as? [String] ?? []
        favList.append(name)
        print("Favourites: \(favList)")
        defaults.set(favList, forKey: "favourites")
        
  }
    
    /// deletes favourited place into user defaults named favourites
    func deleteFavourite(_ name:String){
        var favList: [String] = defaults.object(forKey: "favourites") as? [String] ?? []
        favList.removeAll(where:{$0 == name})
        print(favList)
        defaults.set(favList, forKey: "favourites")
    }
    
    /// get favourite places list  from user defaults named favourites
    func getFavourite() -> [String]{
        let favList:[String] = defaults.object(forKey: "favourites") as? [String] ?? []
        return favList
    }
    
    /// checks if a place is favourite
    func isFavourite(_ name:String) -> Bool{
        let favList:[String] = defaults.object(forKey: "favourites") as? [String] ?? []
        print(favList)
        return favList.contains(name)
    }
    
    // MARK: Hotels
    /// saves favourited hotels into userdefaults favourite hotels
    func saveFavoriteHotels(_ place:String, _ name:String) {
        var favHotels:[String:[String]] = defaults.object(forKey: "favouritehotels") as? [String:[String]] ?? [:]
        print(favHotels)
        if favHotels.keys.contains(place){
            favHotels[place]?.append(name)
        }
        else{
            favHotels[place] = [name]
        }
        defaults.set(favHotels, forKey: "favouritehotels")
        print(favHotels)
        
  }
    
    /// deletes favourited hotels from userdefaults favourite hotels
    func deleteFavouriteHotel(_ place:String,_ name:String){
        var favHotels:[String:[String]] = defaults.object(forKey: "favouritehotels") as? [String:[String]] ?? [:]
        var li = favHotels[place]
        li?.removeAll(where:{$0==name})
        favHotels[place] = li
        defaults.set(favHotels, forKey: "favouritehotels")
        print(favHotels)
    }
    
    /// gets all favourites hotels of a place
    func getFavouriteHotels(_ place:String)-> [String]{
        let favHotels:[String:[String]] = defaults.object(forKey: "favouritehotels") as? [String:[String]] ?? [:]
        return favHotels[place] ?? []
    }
    
    /// gets all favourited hotels
    func getFavouriteHotelsall()-> [String:[String]]{
        let favHotels:[String:[String]] = defaults.object(forKey: "favouritehotels") as? [String:[String]] ?? [:]
        return favHotels
    }
    
    /// checks if a hotel is favourited
    func isFavouriteHotel(_ place:String, _ name:String)->Bool{
        let favHotels:[String:[String]] = defaults.object(forKey: "favouritehotels") as? [String:[String]] ?? [:]
        print(favHotels)
        guard let places = favHotels[place]
        else {
            return false
        }
        return places.contains(name)
    }
    
    /// sorts the hotels based on pricelevel and rating
    func getsortedhotels(_ hotels:[Place],_ place:String, _ sort:String) {
        if (sort == "Price"){
            sortedPlaces = hotels.sorted{
                ($0.price_level!) < ($1.price_level!)
            }
        }
        else if (sort == "Rating"){
            sortedPlaces = hotels.sorted{
                ($0.rating!) > ($1.rating!)
            }
        }
    }
    
    
    // MARK: restaurant
    /// saves favourited hotels into userdefaults favourite restaurant
    func saveFavoriteRestaurants(_ place:String, _ name:String) {
        var favrestaurant:[String:[String]] = defaults.object(forKey: "favouriteRestaurant") as? [String:[String]] ?? [:]
        print(favrestaurant)
        if favrestaurant.keys.contains(place){
            favrestaurant[place]?.append(name)
        }
        else{
            favrestaurant[place] = [name]
        }
        print(favrestaurant)
        defaults.set(favrestaurant, forKey: "favouriteRestaurant")
        
  }
    
    /// deletes favourited restaurant from userdefaults
    func deleteFavouriteRestaurant(_ place:String,_ name:String){
        var favrestaurant:[String:[String]] = defaults.object(forKey: "favouriteRestaurant") as? [String:[String]] ?? [:]
        var li = favrestaurant[place]
        li?.removeAll(where:{$0==name})
        favrestaurant[place] = li
        print(favrestaurant)
        defaults.set(favrestaurant, forKey: "favouriteRestaurant")
    }
    
    /// gets all favourites restaurants of a place
    func getFavouriteRestaurants(_ place:String)-> [String]{
        let favrestaurant:[String:[String]] = defaults.object(forKey: "favouriteRestaurant") as? [String:[String]] ?? [:]
        return favrestaurant[place] ?? []
    }
    
    /// gets if a restaurant if favourite
    func isFavouriteRestaurant(_ place:String, _ name:String)->Bool{
        let favrestaurant:[String:[String]] = defaults.object(forKey: "favouriteRestaurant") as? [String:[String]] ?? [:]
        print(favrestaurant)
        guard let places = favrestaurant[place]
        else {
            return false
        }
        return places.contains(name)
      
    }
    
    /// gets all favourite restaurants
    func getFavouriterestall()-> [String:[String]]{
        let favrestaurant:[String:[String]] = defaults.object(forKey: "favouriteRestaurant") as? [String:[String]] ?? [:]
        return favrestaurant
    }
    
    /// sorts restaurants based on price_leval and rating
    func getsortedRestaurants(_ restaurants:[Place],_ place:String, _ sort:String) {
        if (sort == "Price"){
            sortedPlaces = restaurants.sorted{
               ($0.price_level!) < ($1.price_level!)
            }
        }
        else if (sort == "Rating"){
            sortedPlaces = restaurants.sorted{
                ($0.rating!)  > ($1.rating!)
            }
            
        }
        print("sorttedhotels")
    }
}
