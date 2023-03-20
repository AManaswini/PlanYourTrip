//
//  HomeView2.swift
//  PlanYourTrip
//
//  Created by Manaswini Aitha on 05/03/23.
//

import SwiftUI
import MapKit
struct HomeView2: View {
    var hotels:PlacesClient
    var placesdata:PlacesClient
    init(hotels:PlacesClient,placesdata:PlacesClient){
        self.hotels = hotels
        self.placesdata = placesdata
        
    }
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 41.86626100000001,
            longitude:  -87.6169805),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01)
    )
    //MARK: state variables for dynamically changing the view
    @State private var destination = ""
    @State private var showTabBar = true
    @State private var showingSheet = false
    @State private var showList = false
    @State private var showMap = true
    @State var currentScale:CGFloat = 0
    @State var finalScale:CGFloat = 1
    @State private var rotate = false
    var body: some View {
        
        NavigationView{
            ZStack{
                if showMap{
                VStack{
                    // Attribution: https://www.createwithswift.com/using-mapkit-with-swiftui/
                    Map(coordinateRegion: $region, annotationItems: placesdata.places){
                        place in
                        MapAnnotation(coordinate:CLLocationCoordinate2DMake(CLLocationDegrees(place.geometry!.location.lat), CLLocationDegrees(place.geometry!.location.lng))){
                            NavigationLink {
                                DetailView(place: place, hoteldata:hotels)
                            } label: {
                                AnnotationView(title: place.name!, img: (place.photos?[0].photo_reference)!)
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.all).navigationTitle("Plan Your Trip").toolbarBackground(Color.indigo, for: .navigationBar).toolbarBackground(.visible, for: .navigationBar)
                    
                }.searchable(text: $destination, prompt: "Enter your dream city to visit"){
                    
                    let suggestions: [String] = [
                        "New York", "Chicago", "SanFransisco"
                    ]
                    ForEach(suggestions, id: \.self) { suggestion in
                        Text(suggestion)
                            .searchCompletion(suggestion)
                    }
                }.foregroundColor(Color.black).onSubmit(of: .search) {
                    // get data from api based on the place searched for and display map along the first place extracted
                    let dest = destination.replacingOccurrences(of: " ", with: "")
                    Task {
                        await placesdata.getPlaces(city: dest)
                    }
                    // placesdata.getPlaces(city: dest)
                    var firstplacelat = CLLocationDegrees(0)
                    var firstplacelong = CLLocationDegrees(0)
                    if placesdata.places == []{
                        firstplacelat = CLLocationDegrees(0)
                        firstplacelong = CLLocationDegrees(0)
                    }
                    else{
                        firstplacelat = placesdata.places[0].geometry!.location.lat
                        firstplacelong = placesdata.places[0].geometry!.location.lng
                    }
                    region = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: firstplacelat,
                            longitude: firstplacelong),
                        span: MKCoordinateSpan(
                            latitudeDelta: 0.015,
                            longitudeDelta: 0.015)
                    )
                    
                }
                //.transition(AnyTransition.scale.animation(.easeOut(duration: 0.25)))
            }
                else{
                    List(placesdata.places){ place in
                        VStack{
                            NavigationLink(destination: DetailView(place: place, hoteldata:hotels)){
                                VStack{
                                    Text(place.name!).font(.custom("Acme-Regular", size: 20))
                                }
                                
                            }
                        }.padding(.all).clipShape(RoundedRectangle(cornerRadius: 12))
                        
                    }
                    //.transition(AnyTransition.scale.animation(.easeOut(duration: 0.25)))
                }
                VStack{
                    Spacer()
                    HStack(spacing:0){
                        Spacer()
                            Label("List",systemImage: "list.bullet.clipboard").fontWeight(.medium)
                                .font(.custom("Acme-Regular", size: 15)).frame(height:20)
                                .foregroundColor(.white).padding().background(Color.indigo).shadow(radius: 2).onTapGesture {
                                    self.showList = true
                                    self.showMap = false
                                    rotate.toggle()
                                }
                        Label("Map",systemImage: "mappin").fontWeight(.medium)
                            .font(.custom("Acme-Regular", size: 15)).frame(height:20)
                            .foregroundColor(.white).padding().background(Color.indigo).shadow(radius: 2).onTapGesture {
                                self.showMap = true
                                self.showList = false
                            }
                        Spacer()
                    }
                    
                }
            }
            
        }
    }
    
}
    
struct HomeView2_Previews: PreviewProvider {
    static var previews: some View {
        HomeView2(hotels:PlacesClient(),placesdata:PlacesClient())
    }
}
