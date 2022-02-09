//
//  CategoryListRow.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import SwiftUI

struct CategoryListRow: View {
    var category: CategoryModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(category.name)
                .font(.headline)

            Text(category.creationDate.toLocalizedString())
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }

    }
}
