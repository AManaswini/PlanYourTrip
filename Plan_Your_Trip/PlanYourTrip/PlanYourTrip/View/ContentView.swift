//
//  ContentView.swift
//  PlanYourTrip
//
//  Created by Manaswini Aitha on 21/02/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var hotelsclient: PlacesClient
    @ObservedObject var placesClient: PlacesClient
    // MARK: Indicates when to dismiss splash page
    @State var splashDone: Bool = false
    // MARK: Detect Network changes
    @StateObject var networkMonitor = NetworkMonitor()
    @State private var showNetworkAlert = false
    var body: some View {
        
        /// tabview for home screen and favourites
        VStack {
            // displays splash screen
            if  splashDone == false {
                SplashScreen().opacity(splashDone ? 0 : 1)
            }
            else{
                
                NavigationView {
                    TabView{
                        HomeView2(hotels: self.hotelsclient, placesdata: self.placesClient).tabItem {Label("Home", systemImage:"house")}.tag(1).toolbar(.visible, for: .tabBar).toolbarBackground(Color.indigo, for: .tabBar).toolbarBackground(.visible, for: .tabBar)
                        FavouritesView(model: Model()).tabItem { Label("Favourites", systemImage:"heart.fill")}.tag(2).toolbar(.visible, for: .tabBar).toolbarBackground(Color.indigo, for: .tabBar).toolbarBackground(.visible, for: .tabBar)
                    }
                }.environmentObject(networkMonitor)
                    .onChange(of: networkMonitor.isConnected) { connection in
                        showNetworkAlert = connection == false
                    }
                    .alert(
                        "Network connection seems to be offline. Search functions may be limited.",
                        isPresented: $showNetworkAlert
                    ) {}
            }
        }
        .environmentObject(networkMonitor)
            .onAppear {
            // Attribution: https://www.kodeco.com/4503153-how-to-create-a-splash-screen-with-swiftui#toc-anchor-010
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.splashDone = true
                    }
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(hotelsclient:PlacesClient(),placesClient: PlacesClient())
    }
}
