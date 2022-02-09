//
//  CategoryRepository.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

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
}
