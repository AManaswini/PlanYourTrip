//
//  SplashScreen.swift
//  PlanYourTrip
//
//  Created by Wisly Juganda on 3/7/23.
//

import SwiftUI

struct SplashScreen: View {
    @State private var bouncing1 = false
    @State private var bouncing2 = false
    @State var offsetX = 0.0
    @State var offsetYPlane = 0.0
    @State var offsetYCloud = 0.0
    
    var body: some View {
        GeometryReader { proxy in
            // Screen size
            let size = proxy.size
            ZStack {
                LinearGradient(
                    colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                VStack {
                    ZStack {
                        Image(systemName: "paperplane.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: size.width/2, height: size.width/2, alignment: .center)
                            .offset(x: offsetX, y: offsetYPlane-60)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                    offsetYPlane = 30
                                }
                            }

// Attribution:               https://stackoverflow.com/questions/60792529/how-to-make-a-simple-up-and-down-floating-animation-in-switfui
                        Image(systemName: "cloud.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .offset(x: 80, y: 100)
                            .frame(width: size.width/4, height: size.width/4, alignment: .center)
                            .offset(x: offsetX, y: offsetYCloud-60)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.25).repeatForever(autoreverses: true)) {
                                    offsetYCloud = 35
                                }
                            }
                    }
                    .frame(width: size.width, height: size.width*0.45, alignment: .top)
                    Text("PlanYourTrip")
                        .font(.custom("Acme-Regular", size: 50)).foregroundColor(.white)
                        .foregroundColor(.white)
                        .tracking(-1)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
