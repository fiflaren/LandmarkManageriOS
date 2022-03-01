//
//  LandmarkDetails.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 01/03/2022.
//

import SwiftUI
import CoreData

struct LandmarkDetails: View {
    @State var landmark: LandmarkModel
    @State private var isAnimating: Bool = true
    
    var body: some View {
        let imageClipShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
        
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                ZStack {
                    Image(uiImage: landmark.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 50)
                        .opacity(isAnimating ? 0 : 0.75)
                        .padding(10)
                    
                    Image(uiImage: landmark.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(imageClipShape)
                        .overlay(imageClipShape.strokeBorder(.quaternary, lineWidth: 0.5))
                        .accessibility(hidden: true)
                        .offset(y: isAnimating ? -50 : 0)
                    .opacity(isAnimating ? 0 : 1)
                }
                
                Group {
                    HStack(alignment: .center, spacing: 25) {
                        HStack {
                            Image(systemName: "calendar").imageScale(.small)
                            Text(landmark.modificationDate.toLocalizedString()).font(.caption)
                        }
                        
                        HStack {
                            Image(systemName: "folder.fill").imageScale(.small)
                            Text(landmark.category?.name ?? "Catégorie inconnue").font(.caption)
                        }
                        
                        HStack {
                            Button {
                                landmark.isFavorite.toggle()
                            } label: {
                                if landmark.isFavorite {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(Color.accentColor)
                                } else {
                                    Image(systemName: "heart")
                                        .foregroundColor(Color.gray)
                                }
                            }
                        }
                    }.padding(.bottom,5).foregroundColor(Color.gray)
                }
                .offset(y: isAnimating ? -50 : 0)
                .opacity(isAnimating ? 0 : 1)
                
                Text(html: landmark.desc)
            }
            .padding()
            
            LandmarkMapView(showDetailsOnTap: false, mapLandmarks: [landmark])
                .frame(height: 300, alignment: .center)
                .clipShape(imageClipShape)
                .padding()

        }
        .navigationTitle(landmark.title)
        .onAppear {
            withAnimation(.easeOut(duration: 1)) {
                isAnimating = false
            }
        }
        
    }
    
    
}

struct LandmarkDetails_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetails(landmark: LandmarkModel(id: 1, objectId: NSManagedObjectID(), title: "test", desc: "test", image: UIImage(systemName: "pencil")!, isFavorite: true, creationDate: Date(), modificationDate: Date(), category: CategoryModel(id: 1, objectId: NSManagedObjectID(), name: "test", creationDate: Date(), modificationDate: Date(), landmarks: []), location: CoordinateModel(lat: 2.0, lng: 2.0)))
    }
}
