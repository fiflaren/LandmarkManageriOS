//
//  SplashScreen.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import SwiftUI

struct SplashScreenView: View {
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("icon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .clipped()
            }
            .ignoresSafeArea()
            
            
            Rectangle()
                .background(.regularMaterial)
                .frame(width: 150, height: 150, alignment: .center)
                .cornerRadius(10)
                .overlay {
                    Spinner(animate: .constant(true))
                }
        }
        
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
