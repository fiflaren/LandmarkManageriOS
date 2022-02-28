//
//  CategoryRepository.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import CoreData

enum CategoryError: Error, LocalizedError {
    case notFound
    case failedFetchingFromDb
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "categoryList_notFound".localized
        case .failedFetchingFromDb:
            return "categoryList_failedFetchingFromDb".localized
        }
    }
}

class CategoryRepository {
    var categories: [Category] = []
    var selectedCategoryId: NSManagedObjectID? = nil

    private var coreDataManager: CategoryCoreDataManager
    
    static var shared: CategoryRepository = CategoryRepository(coreDataManager: CoreDataManagerImpl.shared)
    
    private init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        fetchCategories()
    }
    
    func fetchCategories(searchQuery: String? = nil) {
        do {
            categories = try coreDataManager.fetchCategories(searchQuery: searchQuery)
            print(categories)
        } catch {
            fatalError()
        }
    }
    
    func addCategory(name: String) {
        categories.append(coreDataManager.addCategory(name: name))
    }
    
    func deleteCategory(categoryIndex: Int) throws {
        coreDataManager.deleteCategory(category: categories[categoryIndex])
        categories.remove(at: categoryIndex)
    }
    
    func editCategory(categoryIndex: Int, newName: String) throws {
        let category = categories[categoryIndex]
        category.name = newName
        category.modificationDate = Date()
        coreDataManager.editCategory()

    }
}
