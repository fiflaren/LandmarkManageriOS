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
        VStack(alignment: .leading) {
            Text(landmark.title)
                .font(.headline)

            Text(landmark.creationDate.toLocalizedString())
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }

    }
}
