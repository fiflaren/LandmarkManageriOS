//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import CoreLocation
import CoreData

@MainActor class LandmarkListViewModel: ObservableObject {
   
    var selectedCategory: CategoryModel
    @Published var landmarks = [LandmarkModel]()
    @Published var isLoading: Bool = true
    @Published var selectedLandmark: LandmarkModel?
    @Published var error: ErrorDisplayWrapper?
    @Published var sortBy: Int = 0 {
        didSet {
            // if the previously selected option has been tapped again
            // invert the sorting order
            // else reset it to ascending sorting
            if sortBy == oldValue {
                sortByDescending.toggle()
            } else {
                sortByDescending = false
            }
            
            fetchLandmarks()
        }
    }
    @Published var sortByDescending: Bool = false
    
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
            switch ListSortingProperty.init(rawValue: sortBy) {
            case .name:
                return (landmark1.title < landmark2.title) != sortByDescending
            case .creationDate:
                return (landmark1.creationDate < landmark2.creationDate) != sortByDescending
            case .modificationDate:
                return (landmark1.modificationDate < landmark2.modificationDate) != sortByDescending
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
    
    func deleteLandmark(landmarkId: NSManagedObjectID) {
        do {
            try landmarkRepository.deleteLandmark(landmarkId: landmarkId)
            fetchLandmarks()
        } catch {
            self.error = ErrorDisplayWrapper.specificError(error)
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

