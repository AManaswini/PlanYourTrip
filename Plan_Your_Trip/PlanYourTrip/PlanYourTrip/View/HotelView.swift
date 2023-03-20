//
//  HotelView.swift
//  PlanYourTrip
//
//  Created by Manaswini Aitha on 21/02/23.
//

import SwiftUI

struct HotelView: View {
    @State private var toggle:Bool = true
    @State private var sortToggle:Bool = false
    @State private var ratingToggle:Bool = false
    @State private var toggleView:Bool = true
    var place:Place
    @ObservedObject var hotels:PlacesClient
    @State var hotelsData = [Place]()
    init(place:Place, hotels:PlacesClient){
        self.place = place
        self.hotels = hotels
        self.hotels.hotelsLoaded = false
    }
    /// sortedHotels contains hotels that are sorted
    var sortedHotels: [Place] {
        var hotelsToSort = hotelsData
        if sortToggle {
            DataManager.sharedInstance.getsortedhotels(hotelsToSort, place.name!, "Price")
            hotelsToSort = DataManager.sharedInstance.sortedPlaces
        }
        else if ratingToggle{
            DataManager.sharedInstance.getsortedhotels(hotelsToSort, place.name!, "Rating")
            hotelsToSort = DataManager.sharedInstance.sortedPlaces
        }
        return hotelsToSort
    }
    var body: some View {
        if hotels.hotelsLoaded {
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
            List(self.sortedHotels) { hotel in
                let stars = (hotel.rating!)
                let dollars = (hotel.price_level ?? 0)
                
                VStack{
                    AsyncImage(url: URL(string:"https://raw.githubusercontent.com/wvjug/app-photo/main/\(hotel.photo!).jpg")) { image in
                        image.resizable().frame(height: 300)
                    } placeholder: {
                        Image(uiImage: UIImage(named: "AppIcon")!).resizable().frame(height: 300)
                    }.cornerRadius(12).shadow(radius: 10)
                    
                    HStack{
                        Text(hotel.name!).font(.custom("Acme-Regular", size: 20))
                        Image(systemName: DataManager.sharedInstance.isFavouriteHotel(place.name!, hotel.name!) ? "heart.fill" : "heart").foregroundColor(Color.red)
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
                    
                    Text(DataManager.sharedInstance.isFavouriteHotel(place.name!, hotel.name!) ? "Remove" : "Wishlist").fontWeight(.medium)
                        .font(.custom("Acme-Regular", size: 20))
                        .foregroundColor(.white).padding().background(Color.indigo).cornerRadius(12).shadow(radius: 2)
                        .onTapGesture{
                            print("tapped")
                            print(self.toggle)
                            if DataManager.sharedInstance.isFavouriteHotel(place.name!, hotel.name!){
                                // already fav now tapped to delete
                                print("already in fav, now delete")
                                DataManager.sharedInstance.deleteFavouriteHotel(place.name!, hotel.name!)
                                self.toggle.toggle()
                                print(self.toggle)
                            }
                            else{
                                print(self.toggle)
                                print("saved in favs")
                                DataManager.sharedInstance.saveFavoriteHotels(place.name!, hotel.name!)
                                self.toggle.toggle()
                                print(self.toggle)
                            }
                        }
                }.cornerRadius(12).background(LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .top, endPoint: .bottom)).clipShape(RoundedRectangle(cornerRadius: 12))
            }
        } .onChange(of: toggle) { newValue in
            toggleView.toggle()
        }
        } else {
            Spacer()
            Spinner()
                .onAppear {
                    self.hotels.getHotels(placeName: place.name!, lat: Float(place.geometry!.location.lat), lng: Float(place.geometry!.location.lng)) { hotels, error in
                        if let hotels = hotels {
                            self.hotelsData = hotels
                        }
                        else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            Spacer()
        }
    }
    
    struct HotelView_Previews: PreviewProvider {
        static var previews: some View {
            let place = Place(place_id:"1", geometry: Geometry(location: LocationDoc(lat: 41.8827, lng: -87.6233)), name: "The Bean", price_level: 0, rating: 4, types: ["tourist_attraction"], photos: [Photo(photo_reference: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Buckingham_Fountain_Wikivoyage.jpg/2880px-Buckingham_Fountain_Wikivoyage.jpg")])
            HotelView(place:place, hotels: PlacesClient())
        }
    }
}
