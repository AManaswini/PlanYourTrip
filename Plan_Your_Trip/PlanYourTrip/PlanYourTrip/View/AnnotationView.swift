//
//  AnnotationView.swift
//  PlanYourTrip
//
//  Created by Manaswini Aitha on 04/03/23.
//

import SwiftUI
import MapKit

struct AnnotationView: View {
    // https://dev.to/fassko/exploring-swiftui-map-custom-annotations-5co7
    @State private var showTitle = true
    @State var emojis = []
    @State var isHover = false
    let title: String
    let img:String
    let gitHubURl = "https://raw.githubusercontent.com/wvjug/app-photo/main/field%20museum.jpg"
    init(title: String, img: String){
        self.title = title
        self.img = img
        print("https://raw.githubusercontent.com/wvjug/app-photo/main/\(title.convertedToSlug()).jpg")
    }
   
    var body: some View {
        VStack{
            Text(title)
                .opacity(1)
                .foregroundColor(.black).font(.custom("Acme-Regular", size: 10))
            VStack{
                AsyncImage(url: URL(string:"https://raw.githubusercontent.com/wvjug/app-photo/main/\(title.convertedToSlug()).jpg")) { image in
                    image.resizable().aspectRatio(contentMode: .fill).frame(width:40,height: 40).clipShape(Circle()).overlay{
                        Circle().stroke(.indigo, lineWidth: 4)
                    }
                } placeholder: {
                    Image(uiImage: UIImage(named: "AppIcon")!).aspectRatio(contentMode: .fill).frame(width:40,height: 40).clipShape(Circle()).overlay{
                        Circle().stroke(.indigo, lineWidth: 4)
                    }
                }  
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.custom("Acme-Regular", size: 8))
                    .foregroundColor(.indigo)
            }.frame(width:30,height: 30)             
        }
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView(title: "Buckingham Fountain", img:"")
    }
}
