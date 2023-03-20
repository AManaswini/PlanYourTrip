## Team members
Manaswini Aitha
Wisly Juganda


## Device Compatibility
App is optimized for iPhone use only, requiring a minimum of iOS version 16.0
Cache is implemented using NSCache which only saves to memory so cache is cleared if app is terminated

## Third-party Libraries
ConfettiSwiftUI - https://github.com/simibac/ConfettiSwiftUI
Spinner (from SwiftUI-Animation) - https://github.com/KeatoonMask/SwiftUI-Animation

## Third-party API
Google Places Search API - https://developers.google.com/maps/documentation/places/web-service/search

## App functionality
1. Mapview by default shows places of interest in Chicago on loading.
2. On searching any place and clicking enter, map zooms to that area and displays annotations
3. Users can view a list by clicking on the list icon and switch between list and map view.
4. On clicking an annotation or place in the list, more details about the place are displayed.
5. Users can add them to their favourites list and remove them as well.
6. Users can find nearby hotels and restaurants of that place by clicking on hotel and restaurant icons.
7. Users can sort the hotel and restaurant suggestion by price level in ascending order(0 being the lowest and 5 being the highest) and sort by rating from high to low(5 being the highest and 0 being the lowest).
8. Users can add the hotels and restauarnts top their favourite list.
9. All the favourited places, hotels and restaurants are visible in the favourites tab.


## Issues Encountered
Flights API - Initially we were going to implement a feature to search for flights but after extensive texting with multiple APIs, we found that none of
the free APIs for Flight data are stable.

Google Photos API - Place photos should have been pulled from Google Photos API but due to rate limiting issues from a free account, we ended up creating
a github repo for which we manually uploaded photos of some places and fetching them from our own GitHub repository at 
https://github.com/wvjug/app-photo. This is the main reason why we have limited our scope to only Chicago, New York and San Fransisco despite having the 
capability to search any city.

Favorites Detail View - The feature to look at place details from selecting places in the favorites list was deprecated due to the difficulty of saving 
custom objects to disk.

The app shows the following error 
"Publishing changes from within view updates is not allowed, this will cause undefined behavior."
This is a bug in IOS version which generally occurs when a binding variable is used as a published variable.But the app doesnt use any.Moreover this warning doesnt effect the performance of the app. 


PlanYourTrip/PlanYourTrip/Model/Places.swift:    // Attribution: https://praveenkommuri.medium.com/how-to-read-parse-local-json-file-in-swift-28f6cec747cf
PlanYourTrip/PlanYourTrip/View/DetailView.swift:        // Attribution: https://stackoverflow.com/questions/57102209/how-can-i-avoid-nested-navigation-bars-in-swiftui
PlanYourTrip/PlanYourTrip/View/DetailView.swift:                    // Attribution: https://www.appcoda.com/swiftui-confetti-animation/
PlanYourTrip/PlanYourTrip/View/HomeView2.swift:                    // Attribution: https://www.createwithswift.com/using-mapkit-with-swiftui/
PlanYourTrip/PlanYourTrip/View/SplashScreen.swift:// Attribution:               https://stackoverflow.com/questions/60792529/how-to-make-a-simple-up-and-down-floating-animation-in-switfui
PlanYourTrip/PlanYourTrip/View/ContentView.swift:            // Attribution: https://www.kodeco.com/4503153-how-to-create-a-splash-screen-with-swiftui#toc-anchor-010
