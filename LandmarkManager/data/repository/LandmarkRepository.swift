//
//  CategoryRepository.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import UIKit

enum LandmarkError: Error, LocalizedError {
    case notFound
    case noLocation
    case badImage
    case failedCreating
    case emptyLocation
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "categoryList_notFound".localized
        case .noLocation:
            return "landmarkList_notFound".localized
        case .badImage:
            return "landmarkList_badImage".localized
        case .failedCreating:
            return "newLandmarkList_failedCreating".localized
        case .emptyLocation:
            return "newLandmarkList_emptyLocation".localized
        }
    }
}

class LandmarkRepository {
    var landmarks: [Landmark] = []

    private var coreDataManager: CoreDataManager
    
    static var shared: LandmarkRepository = LandmarkRepository(coreDataManager: CoreDataManagerImpl.shared)
    
    private init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        fetchLandmarks()
    }
    
    func fetchLandmarks(searchQuery: String? = nil) {
        landmarks = coreDataManager.fetchLandmarks(searchQuery: searchQuery)
    }
    
    func addLandmark(name: String, description: String, image: UIImage, coordinate: CoordinateModel, category: CategoryModel) throws {
        guard let imageData = image.pngData() else {
            throw LandmarkError.badImage
        }
        
        guard let landmark = coreDataManager.addLandmark(name: name, description: description, image: imageData, coordinate: coordinate, category: category) else {
            throw LandmarkError.failedCreating
        }
        
        landmarks.append(landmark)
    }
    

//    func deleteCategory(categoryIndex: Int) throws {
//        coreDataManager.deleteCategory(category: categories[categoryIndex])
//        categories.remove(at: categoryIndex)
//    }
//
//    func editCategory(categoryIndex: Int, newName: String) throws {
//        let category = categories[categoryIndex]
//        category.name = newName
//        category.modificationDate = Date()
//        coreDataManager.editCategory()
//
//    }
}
