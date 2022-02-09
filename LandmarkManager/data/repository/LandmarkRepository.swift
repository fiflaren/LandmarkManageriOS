//
//  CategoryRepository.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

enum LandmarkError: Error, LocalizedError {
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return NSLocalizedString("Category not found", comment: "")
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
    
//    func addCategory(name: String) {
//        categories.append(coreDataManager.addCategory(name: name))
//    }
//
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
