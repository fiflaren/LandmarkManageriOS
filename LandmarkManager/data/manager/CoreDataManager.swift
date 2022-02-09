//
//  DbManager.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

protocol CoreDataManager {
    func fetchCategories(searchQuery: String?) -> [Category]
    func addCategory(name: String) -> Category
    func deleteCategory(category: Category)
    func editCategory()
}
