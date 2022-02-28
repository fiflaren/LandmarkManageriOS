//
//  AddLandmarkViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import Foundation
import MapKit

@MainActor class AddLandmarkViewModel: ObservableObject {
    
    @Published var categories: [CategoryModel] = []
    @Published var selectedCategoryIndex: Int = 0
    @Published var chosenLocation: LandmarkLocation? = nil
    
    private var locationManager = LocationManager.shared
        
    init() {
        fetchCategories()
    }
    
    private func fetchCategories() {
        categories = CategoryRepository.shared.categories.enumerated().map({ (index, category) in
            Mapper.shared.mapCategoryDbEntityToModel(entity: category, id: index)
        })
        
        guard let selectedCategory = CategoryRepository.shared.selectedCategoryId else {
            return
        }
        
        let index = categories.firstIndex { category in
            category.objectId == selectedCategory
        }
        
        selectedCategoryIndex = index ?? 0
        
    }
    
}
