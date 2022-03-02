//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import CoreLocation
import CoreData

enum LandmarkListSortingProperty: Int {
    case nameAsc = 0
    case nameDesc = 1
    case dateAsc = 2
    case dateDesc = 3
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
            case .nameAsc:
                return landmark1.title < landmark2.title
            case .nameDesc:
                return landmark1.title > landmark2.title
            case .dateAsc:
                return landmark1.modificationDate > landmark2.modificationDate
            case .dateDesc:
                return landmark1.modificationDate < landmark2.modificationDate
            case .none:
                return false
            }
        })
        isLoading = false
    }
    
    func getLandmarks(favorite: Bool) -> [LandmarkModel] {
        return landmarks.filter { landmark in
            landmark.isFavorite == favorite
        }
    }
    
    func toggleLandmarkFavorite(landmarkId: NSManagedObjectID) {
        do {
            try landmarkRepository.toggleLandmarkFavorite(landmarkId: landmarkId)
        } catch {
            self.error = ErrorDisplayWrapper.specificError(error)
        }
    }
}

