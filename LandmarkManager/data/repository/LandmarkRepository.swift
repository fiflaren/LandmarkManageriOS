//
//  CategoryRepository.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import UIKit
import CoreData

enum LandmarkError: Error, LocalizedError {
    case notFound
    case noLocation
    case badImage
    case failedCreating
    case failedEditing
    case emptyLocation
    case emptyName
    case emptyDescription

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
        case .failedEditing:
            return "newLandmarkList_failedEditing".localized
        case .emptyLocation:
            return "newLandmarkList_emptyLocation".localized
        case .emptyName:
            return "newLandmarkList_emptyName".localized
        case .emptyDescription:
            return "newLandmarkList_emptyDescription".localized
            
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
    
    func editLandmark(editedLandamrk: LandmarkModel) throws {
        guard let landmarkToEdit = findLandmarkById(id: editedLandamrk.objectId) else {
            throw LandmarkError.notFound
        }
        
        landmarkToEdit.title = editedLandamrk.title
        landmarkToEdit.desc = editedLandamrk.desc
        
        if let category = editedLandamrk.category {
            do {
                landmarkToEdit.category = try coreDataManager.fetchCategoryById(id: category.objectId)
            } catch {
                throw LandmarkError.failedEditing
            }
        }
        
        landmarkToEdit.coordinate = coreDataManager.createCoordinate(lat: editedLandamrk.mapLocation.latitude, lng: editedLandamrk.mapLocation.longitude)
        landmarkToEdit.image = editedLandamrk.image.pngData()
        landmarkToEdit.modificationDate = Date()
        coreDataManager.editLandmark()
    }
    
    func toggleLandmarkFavorite(landmarkId: NSManagedObjectID) throws {
        guard let landmark = findLandmarkById(id: landmarkId) else {
            throw LandmarkError.notFound
        }

        landmark.isFavorite.toggle()
        coreDataManager.editLandmark()
    }
    
    private func findLandmarkById(id: NSManagedObjectID) -> Landmark? {
        guard let landmarkToEdit = landmarks.first(where: { $0.objectID == id }) else {
            return nil
        }
        
        return landmarkToEdit
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
