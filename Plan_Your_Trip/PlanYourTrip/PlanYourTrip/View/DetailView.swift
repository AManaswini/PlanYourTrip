//
//  DetailView.swift
//  PlanYourTrip
//
//  Created by Manaswini Aitha on 21/02/23.
//

import SwiftUI
import ConfettiSwiftUI
/// describes about an annotation
struct DetailView: View {
    var place: Place
    var hoteldata: PlacesClient
    @State private var showingPopoverHotel = false
    @State private var showingPopoverRestaurant = false
    @State private var counter = 0
    @State private var toggle = true
    @State private var toggleCount = true
    // animation properties
    // is toggled when a place is favourited
    @State var isTapped:Bool = false
    @State var startAnimation = false
    @State private var rotate = false
    // timers to display stars and dollars with animation
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    let timer2 = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    @State private var starCounter = 0
    @State private var dollarCounter = 0
    // reloads the screen on changing the toggle property
    @State private var toggleView:Bool = true
    init(place:Place,hoteldata: PlacesClient){
        
        self.place = place
        self.hoteldata = hoteldata
    }
    var body: some View {
        let stars = Int(place.rating!)
        let dollars = Int(place.price_level ?? 0)
        // hiding nested nav bars
        // Attribution: https://stackoverflow.com/questions/57102209/how-can-i-avoid-nested-navigation-bars-in-swiftui
        //NavigationView{
        ScrollView{
        VStack{
            AsyncImage(url: URL(string:"https://raw.githubusercontent.com/wvjug/app-photo/main/\(place.photo!).jpg")) { image in
                image.resizable().frame(height: 300)
            } placeholder: {
                Image(uiImage: UIImage(named: "hotel1")!).resizable().frame(height: 300)
            }.cornerRadius(12).shadow(radius: 10).padding(0)
                VStack{
                    HStack{
                        Text(place.name!).font(.custom("Acme-Regular", size: 40)).foregroundColor(.white)
                        Image(systemName: DataManager.sharedInstance.isFavourite(place.name!) ? "heart.fill" : "heart").foregroundColor(Color.red).rotation3DEffect(.degrees(rotate ? 180 : -180), axis: (x: 0, y: 1, z: 0))
                            .animation(.linear(duration: 5).repeatForever(autoreverses: true), value: rotate).onAppear{
                                rotate.toggle()
                            }
                            .onTapGesture {
                                self.isTapped = true
                                withAnimation(.interactiveSpring(response: 0.5,dampingFraction: 0.6,blendDuration: 0.6)){
                                    startAnimation = true
                                }
                            }.confettiCannon(counter: $counter, num: 12, confettis: [.sfSymbol(symbolName: "heart.fill")], colors: [.red],rainHeight: 25.0, radius: 45.0)
                            .scaleEffect(self.toggle ? 1:2)
                            .animation(.easeIn, value: self.toggle).padding(.leading).foregroundColor(.red)
                        
                    }
                    // using confetti
                    // Attribution: https://www.appcoda.com/swiftui-confetti-animation/
                    // rating
                    HStack{
                        ForEach(0..<starCounter,id: \.self) { _ in
                            Image(systemName: "star.fill").foregroundColor(Color.yellow)
                        }
                    }.padding(.bottom).onReceive(timer) { _ in
                        withAnimation {
                            if starCounter < Int(stars) {
                                starCounter = starCounter + 1
                            } else {
                                timer.upstream.connect().cancel()
                            }
                        }
                    }
                    // price level
                    HStack{
                        ForEach(0..<dollarCounter,id: \.self) { _ in
                            Image(systemName: "dollarsign").foregroundColor(Color.white)
                        }
                    }.onReceive(timer2) { _ in
                        withAnimation {
                            if dollarCounter < Int(dollars) {
                                dollarCounter = dollarCounter + 1
                            } else {
                                timer2.upstream.connect().cancel()
                            }
                        }
                    }
                    HStack{
                        Image(systemName: "bed.double.fill").foregroundColor(.white).padding(.all).background(Color.indigo).cornerRadius(12).shadow(radius: 2).onTapGesture {
                            showingPopoverHotel = true
                        }.popover(isPresented: $showingPopoverHotel) {
                            Image(systemName: "multiply").onTapGesture {
                                showingPopoverHotel = false
                            }.padding(.top)
                            HotelView(place: place, hotels: hoteldata)
                        }
                        
                        Image(systemName: "fork.knife").foregroundColor(.white).padding(.all).background(Color.indigo).cornerRadius(12).shadow(radius: 2).onTapGesture {
                            showingPopoverRestaurant = true
                        }
                        .popover(isPresented: $showingPopoverRestaurant) {
                            Image(systemName: "multiply").onTapGesture {
                                showingPopoverRestaurant = false
                            }.padding(.top)
                            RestaurantView(place: place, restaurant: hoteldata)
                        }
                    }
                    VStack{
                        Text(DataManager.sharedInstance.isFavourite(place.name!) ? "Remove from favourites" : "Add to favourites").fontWeight(.bold).foregroundColor(Color.white)
                            .font(.custom("Acme-Regular", size: 20))
                            .padding()
                    }.background(DataManager.sharedInstance.isFavourite(place.name!) ? Color.red: Color.indigo).cornerRadius(20).shadow(radius: 2).onTapGesture{
                            print("tapped")
                            if DataManager.sharedInstance.isFavourite(place.name!){
                                // already fav now tapped to delete
                                print("already in fav, now delete")
                                DataManager.sharedInstance.deleteFavourite(place.name!)
                                self.toggleCount.toggle()
                                self.toggle = true
                                print(self.toggleCount)
                                
                                
                            }
                            else{
                                DataManager.sharedInstance.saveFavorites(place.name!)
                                self.toggle = false
                                self.counter += 1
                                self.toggleCount.toggle()
                                print(self.toggleCount)
                                
                            }
                        }
                    Spacer()
                }.frame(minWidth: 0,maxWidth: .infinity, maxHeight: .infinity).background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.85)).clipShape(RoundedRectangle(cornerRadius: 12)).padding(0)
                
        }.onChange(of: toggleCount) { newValue in
                toggleView.toggle()
            }
            
        }
        }
    
    struct DetailView_Previews: PreviewProvider {
        static var previews: some View {
            DetailView(place: Place(place_id:"1", geometry: Geometry(location: LocationDoc(lat: 41.8827, lng: -87.6233)), name: "The Bean", price_level: 1, rating: 4.8, types: ["tourist_attraction"], photos: [Photo(photo_reference: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Buckingham_Fountain_Wikivoyage.jpg/2880px-Buckingham_Fountain_Wikivoyage.jpg")]), hoteldata: PlacesClient())
            
        }
    }
    
}
