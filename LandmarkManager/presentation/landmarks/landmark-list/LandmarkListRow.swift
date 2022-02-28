//
//  CategoryListRow.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//


import SwiftUI

struct LandmarkListRow: View {
    var landmark: LandmarkModel
    
    var body: some View {
        HStack(alignment: .top) {
            let imageClipShape = RoundedRectangle(cornerRadius: 10, style: .continuous)
            Image(uiImage: landmark.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(imageClipShape)
                .overlay(imageClipShape.strokeBorder(.quaternary, lineWidth: 0.5))
                .accessibility(hidden: true)

            VStack(alignment: .leading) {
                Text(landmark.title)
                    .font(.headline)
                
                Text(landmark.desc)
                    .lineLimit(2)

                Text(landmark.modificationDate.toLocalizedString())
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
        }
        .font(.subheadline)
        .accessibilityElement(children: .combine)
        .padding(.vertical)
        
    }
}

