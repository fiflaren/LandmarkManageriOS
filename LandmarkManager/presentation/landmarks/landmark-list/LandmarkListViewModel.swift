//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import CoreLocation

@MainActor class LandmarkListViewModel: ObservableObject {
   
    var selectedCategory: CategoryModel
    @Published var landmarks = [LandmarkModel]()
    @Published var mapLandmarks = [LandmarkLocation]()
    @Published var isLoading: Bool = true
    @Published var selectedLandmark: LandmarkModel?
    @Published var error: ErrorDisplayWrapper?
    
    private var landmarkRepository = LandmarkRepository.shared
    
    init(selectedCategory: CategoryModel) {
        self.selectedCategory = selectedCategory
        CategoryRepository.shared.selectedCategoryId = selectedCategory.objectId
        landmarkRepository.fetchLandmarks(searchQuery: nil)
        fetchLandmarks()
    }
    
    func fetchLandmarks() {
        var newLandmarks: [LandmarkModel] = []
        for (index,landmark) in landmarkRepository.landmarks.enumerated() {
            guard let category = landmark.category else {
                continue
            }
            
            if category.objectID != selectedCategory.objectId {
                continue
            }
            
            newLandmarks.append(Mapper.shared.mapLandmarkDbEntityToModel(entity: landmark, id: index))
        }
        
        self.landmarks = newLandmarks
        
        self.mapLandmarks = landmarks.map { landmark in
            LandmarkLocation(title: landmark.title, place: nil, coordinates: landmark.mapLocation)
        }
    }
}

