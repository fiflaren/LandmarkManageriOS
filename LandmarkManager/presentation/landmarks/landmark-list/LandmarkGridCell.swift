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
                    .frame(width: width != nil ? width : .infinity, height: height != nil ? height : .infinity)
                    .overlay(TintOverlay().opacity(0.75))
                    .clipShape(imageClipShape)
                    .accessibility(hidden: true)
                    .blur(radius: 50)
                    .opacity(0.75)
            }
            
            Image(uiImage: landmark.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width != nil ? width : .infinity, height: height != nil ? height : .infinity)
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
                
                Text(landmark.title)
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
            }
            .padding(10)
        }
        .frame(width: width != nil ? width : .infinity, height: height != nil ? height : .infinity)
    }
}

struct LandmarkGridCell_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkGridCell(landmark: LandmarkModel(id: 1, objectId: NSManagedObjectID(), title: "test title", desc: "test desc", image: UIImage(systemName: "pencil")!, isFavorite: true, creationDate: Date(), modificationDate: Date(), category: CategoryModel(id: 1, objectId: NSManagedObjectID(), name: "test", creationDate: Date(), modificationDate: Date(), landmarks: []), location: CoordinateModel(id: UUID(), lat: 2.0, lng: 2.0)), showBackgroundBlur: true)
            .previewLayout(PreviewLayout.sizeThatFits)
        
    }
}

extension Color {
    static var gradient: Array<Color> {
        return [
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.1),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.3),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 1.0),
        ]
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
            LinearGradient(gradient: Gradient(colors: Color.gradient), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}
