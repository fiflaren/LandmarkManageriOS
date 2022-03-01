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
    @Published var error: ErrorDisplayWrapper?

    private var locationManager = LocationManager.shared
        
    init() {
        fetchCategories()
    }
    
    func addLandmark(name: String, description: String, image: UIImage) -> Bool {
        guard let latitude = chosenLocation?.coordinates.latitude,
              let longitude = chosenLocation?.coordinates.longitude
        else {
            error = ErrorDisplayWrapper.specificError(LandmarkError.emptyLocation)
            return false
        }
        
        let coordinate = CoordinateModel(lat: latitude, lng: longitude)
           
        do {
            try LandmarkRepository.shared.addLandmark(name: name, description: description, image: image, coordinate: coordinate, category: categories[selectedCategoryIndex])
            return true
        } catch {
            self.error = ErrorDisplayWrapper.specificError(error)
            return false
        }
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
