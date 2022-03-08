//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import CoreLocation
import CoreData

enum LandmarkListSortingProperty: CaseIterable, Identifiable {
    case nameAsc
    case nameDesc
    case creationDateAsc
    case creationDateDesc
    case modificationDateAsc
    case modificationDateDesc
    
    init(id: Int) {
        switch id {
        case 0:
            self = .nameAsc
        case 1:
            self = .nameDesc
        case 2:
            self = .creationDateAsc
        case 3:
            self = .creationDateDesc
        case 4:
            self = .modificationDateAsc
        case 5:
            self = .modificationDateDesc
        default:
            self = .nameAsc
        }
    }
    
    var id: Int {
        switch self {
        case .nameAsc:
            return 0
        case .nameDesc:
            return 1
        case .creationDateAsc:
            return 2
        case .creationDateDesc:
            return 3
        case .modificationDateAsc:
            return 4
        case .modificationDateDesc:
            return 5
        }
    }
    
    var description: String {
        switch self {
        case .nameAsc:
            return "Titre A-Z"
        case .nameDesc:
            return "Titre Z-A"
        case .creationDateAsc:
            return "Créé le plus récemment"
        case .creationDateDesc:
            return "Créé le moins récemment"
        case .modificationDateAsc:
            return "Modifié le plus récemment"
        case .modificationDateDesc:
            return "Modifié le moins récemment"
        }
    }
}

@MainActor class LandmarkListViewModel: ObservableObject {
   
    var selectedCategory: CategoryModel
    @Published var landmarks = [LandmarkModel]()
    @Published var isLoading: Bool = true
    @Published var selectedLandmark: LandmarkModel?
    @Published var error: ErrorDisplayWrapper?
    @Published var sortBy: Int = 0
    @Published var soryByDescending: Bool = false
    
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
            switch LandmarkListSortingProperty.init(id: sortBy) {
            case .nameAsc:
                return landmark1.title < landmark2.title
            case .nameDesc:
                return landmark1.title > landmark2.title
            case .creationDateAsc:
                return landmark1.creationDate > landmark2.creationDate
            case .creationDateDesc:
                return landmark1.creationDate < landmark2.creationDate
            case .modificationDateAsc:
                return landmark1.modificationDate > landmark2.modificationDate
            case .modificationDateDesc:
                return landmark1.modificationDate < landmark2.modificationDate
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

