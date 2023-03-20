//
//  RestaurantView.swift
//  PlanYourTrip
//
//  Created by Manaswini Aitha on 21/02/23.
//

import SwiftUI
struct RestaurantView: View {
    //MARK: state variables to dynamically load the view
    @State private var toggle:Bool = true
    @State private var sortToggle:Bool = false
    @State private var ratingToggle:Bool = false
    @State private var toggleView:Bool = true
    var place:Place
    @ObservedObject var restaurant:PlacesClient
    @State var restaurantsData = [Place]()
    init(place:Place, restaurant:PlacesClient){
        self.place = place
        self.restaurant = restaurant
        self.restaurant.restaurantsLoaded = false
    }
    var sortedrest: [Place] {
        var restaurantsToSort = restaurantsData
        if sortToggle {
            DataManager.sharedInstance.getsortedRestaurants(restaurantsToSort, place.name!, "Price")
            restaurantsToSort = DataManager.sharedInstance.sortedPlaces
        }
        else if ratingToggle{
            DataManager.sharedInstance.getsortedRestaurants(restaurantsToSort, place.name!, "Rating")
            restaurantsToSort = DataManager.sharedInstance.sortedPlaces
        }
        return restaurantsToSort
    }
    
    var body: some View {
        if restaurant.restaurantsLoaded {
            VStack{
                HStack{
                    Spacer()
                    Menu("Sort") {
                        let t = self.sortToggle ? "Price ✔️": "Price"
                        let r = self.ratingToggle ? "Rating ✔️": "Rating"
                        Button(t) {
                            self.sortToggle.toggle()
                            self.ratingToggle = false
                        }
                        Button(r) {
                            self.ratingToggle.toggle()
                            self.sortToggle = false
                        }
                    }.padding(.trailing)
                    
                }
                List(self.sortedrest) { rest in
                    let stars = (rest.rating!)
                    let dollars = (rest.price_level!)
                    HStack {
                        AsyncImage(url: URL(string:"https://raw.githubusercontent.com/wvjug/app-photo/main/\(rest.photo!).jpg")) { image in
                            image.resizable().frame(height: 100)
                        } placeholder: {
                            Image(uiImage: UIImage(named: "AppIcon")!).resizable().frame(height: 100)
                        }.cornerRadius(12).shadow(radius: 10)
                        
                        VStack {
                            HStack{
                                Text(rest.name!).lineLimit(2).font(.custom("Acme-Regular", size: 20)).minimumScaleFactor(0.5)
                                Image(systemName: DataManager.sharedInstance.isFavouriteRestaurant(place.name!, rest.name!) ? "heart.fill" : "heart").foregroundColor(Color.red)
                            }
                            VStack{
                                HStack{
                                    Text("Price Level  -  \(Int(dollars))").font(.custom("Acme-Regular", size: 20))
                                }
                               HStack{
                                    Text("\(stars, specifier: "%.00f")").font(.custom("Acme-Regular", size: 20))
                                    Image(systemName: "star.fill").foregroundColor(Color.yellow)
                                }
                            }
                            Text(DataManager.sharedInstance.isFavouriteRestaurant(place.name!, rest.name!) ? "Remove" : "Wishlist").fontWeight(.medium)
                                .font(.custom("Acme-Regular", size: 20))
                                .foregroundColor(.white).padding().background(Color.indigo).cornerRadius(12).shadow(radius: 2)
                                .onTapGesture{
                                    print("tapped")
                                    print(self.toggle)
                                    if DataManager.sharedInstance.isFavouriteRestaurant(place.name!, rest.name!){
                                        // already fav now tapped to delete
                                        print("already in fav, now delete")
                                        DataManager.sharedInstance.deleteFavouriteRestaurant(place.name!, rest.name!)
                                        self.toggle.toggle()
                                        print(self.toggle)
                                    }
                                    else{
                                        print(self.toggle)
                                        print("saved in favs")
                                        DataManager.sharedInstance.saveFavoriteRestaurants(place.name!, rest.name!)
                                        self.toggle.toggle()
                                        print(self.toggle)
                                    }
                                }
                            HStack{
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }.onChange(of: toggle) { newValue in
                toggleView.toggle()
            }
        } else {
            Spacer()
            Spinner()
                .onAppear {
                    self.restaurant.getRestaurants(placeName: place.name!, lat: Float(place.geometry!.location.lat), lng: Float(place.geometry!.location.lng)) { restaurants, error in
                        if let restaurants = restaurants {
                            self.restaurantsData = restaurants
                        }
                        else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            Spacer()
        }
    }
    
    struct RestaurantView_Previews: PreviewProvider {
        static var previews: some View {
            let place = Place(place_id:"1", geometry: Geometry(location: LocationDoc(lat: 41.8827, lng: -87.6233)), name: "The Bean", price_level: 0, rating: 4, types: ["tourist_attraction"], photos: [Photo(photo_reference: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Buckingham_Fountain_Wikivoyage.jpg/2880px-Buckingham_Fountain_Wikivoyage.jpg")])
            RestaurantView(place:place, restaurant: PlacesClient())
        }
    }
    
}
