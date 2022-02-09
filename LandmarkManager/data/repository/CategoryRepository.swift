//
//  CategoryRepository.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

enum CategoryError: Error, LocalizedError {
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return NSLocalizedString("Category not found", comment: "")
        }
    }
}

class CategoryRepository {
    var categories: [Category] = []

    private var coreDataManager: CoreDataManager
    
    static var shared: CategoryRepository = CategoryRepository(coreDataManager: CoreDataManagerImpl.shared)
    
    private init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        fetchCategories()
    }
    
    func fetchCategories(searchQuery: String? = nil) {
        categories = coreDataManager.fetchCategories(searchQuery: searchQuery)
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
        coreDataManager.editCategory()

    }
}
