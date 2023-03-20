//
//  PlanYourTripApp.swift
//  PlanYourTrip
//
//  Created by Manaswini Aitha on 21/02/23.
//

import SwiftUI

@main
struct PlanYourTripApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(hotelsclient:PlacesClient(),placesClient: PlacesClient())
        }
    }
}
