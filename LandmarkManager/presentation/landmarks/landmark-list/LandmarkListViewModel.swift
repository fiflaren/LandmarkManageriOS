//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import CoreLocation

enum LandmarkListSortingProperty: Int {
    case name = 0
    case date = 1
    case location = 2
}

@MainActor class LandmarkListViewModel: ObservableObject {
   
    var selectedCategory: CategoryModel
    @Published var landmarks = [LandmarkModel]()
    @Published var isLoading: Bool = true
    @Published var selectedLandmark: LandmarkModel?
    @Published var error: ErrorDisplayWrapper?
    @Published var sortBy: Int = 0
    
    private var landmarkRepository = LandmarkRepository.shared
    
    init(selectedCategory: CategoryModel) {
        self.selectedCategory = selectedCategory
    }
    
    func loadLandmarks() {
        CategoryRepository.shared.selectedCategoryId = selectedCategory.objectId
        DispatchQueue.main.async { [unowned self] in
            landmarkRepository.fetchLandmarks(searchQuery: nil)
        }
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
        
        self.landmarks = newLandmarks.sorted(by: { landmark1, landmark2 in
            switch LandmarkListSortingProperty.init(rawValue: sortBy) {
            case .name:
                return landmark1.title > landmark2.title
            case .date:
                return landmark1.modificationDate > landmark2.modificationDate
            case .location:
                return true
            case .none:
                return false
            }
        })
        isLoading = false
    }
}

