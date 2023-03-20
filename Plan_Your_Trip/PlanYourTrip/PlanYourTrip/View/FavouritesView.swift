//
//  FavouritesView.swift
//  PlanYourTrip
//
//  Created by Manaswini Aitha on 21/02/23.
//

import SwiftUI



struct FavouritesView: View {
    @ObservedObject var model: Model
    @State private var toggleviewfav = false
    @State private var favs = DataManager.sharedInstance.getFavourite()
    @State private var favh = DataManager.sharedInstance.getFavouriteHotelsall().filter{ !$0.value.isEmpty }
    @State private var favr = DataManager.sharedInstance.getFavouriterestall().filter{ !$0.value.isEmpty }
    var body: some View {
        let favlist = Set(Array(self.favs) + Array(self.favh.keys) + Array(self.favr.keys)).sorted()
        VStack{
            Text("My favourites").frame(minWidth: 0,maxWidth: .infinity).background(Color.indigo).font(.custom("Acme-Regular", size: 20))
            List(favlist, id: \.self){ key in
                VStack{
                    Section(header:Text(key).font(.custom("Acme-Regular", size: 20))) {
                        // hotels
                            if let values = self.favh[key]{
                                if values.count != 0{
                                    Section(header: VStack{Text("Hotels").font(.custom("Acme-Regular", size: 20))}.frame(minWidth: 0,maxWidth: .infinity)) {
                                        VStack{
                                            List(values, id: \.self) { value in
                                                Text(value).font(.custom("Acme-Regular", size: 15))
                                            }.background(Color.black)
                                        }.frame(height: CGFloat(values.count) * 80)
                                    }
                                }
                            }
                            
                            // restaurants
                            if let values = self.favr[key]{
                                if values.count != 0{
                                    Section(header: VStack{Text("Restaurants").font(.custom("Acme-Regular", size: 20))}.frame(minWidth: 0,maxWidth: .infinity)) {
                                        
                                        VStack{
                                            List(values, id: \.self) { value in
                                                Text(value).font(.custom("Acme-Regular", size: 20))
                                            }.background(Color.black)
                                        }.frame(height: CGFloat(values.count) * 80)
                                    }
                                }
                            }
                    }.padding(.all)
                }.frame(minWidth: 0,maxWidth: .infinity).background(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(20).padding(.bottom).shadow(radius: 20)
            }.onAppear{
                toggleviewfav.toggle()
                favs = DataManager.sharedInstance.getFavourite()
                favh =  DataManager.sharedInstance.getFavouriteHotelsall().filter{ !$0.value.isEmpty }
                favr = DataManager.sharedInstance.getFavouriterestall().filter{ !$0.value.isEmpty }
            }
        }
    }
            
}
    
    
    
    struct FavouritesView_Previews: PreviewProvider {
        static var previews: some View {
            FavouritesView(model: Model())
        }
    }

