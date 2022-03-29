//
//  LandmarkGridCell.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 08/03/2022.
//

import SwiftUI
import CoreData

struct LandmarkGridCell: View {
    var landmark: LandmarkModel
    var width: CGFloat?
    var height: CGFloat?
    var showBackgroundBlur: Bool
    
    var body: some View {
        let imageClipShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
        ZStack {
            if showBackgroundBlur {
                Image(uiImage: landmark.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(TintOverlay().opacity(0.75))
                    .clipShape(imageClipShape)
                    .accessibility(hidden: true)
                    .blur(radius: 50)
                    .opacity(0.75)
            }
            
            Image(uiImage: landmark.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(TintOverlay().opacity(0.75))
                .clipShape(imageClipShape)
                .accessibility(hidden: true)
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Image(systemName: landmark.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                
                Text(landmark.title.trunc(length: 20))
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
                    .allowsTightening(true)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            .padding(10)
        }
    }
}

struct TintOverlay: View {
    var body: some View {
        ZStack {
            Text(" ")
                .foregroundColor(.white)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: Color.imageBlackOverlayGradient), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}


