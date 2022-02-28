//
//  DbManager.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import CoreData

protocol CoreDataManager: CategoryCoreDataManager, LandmarkCoreDataManager  {
    
}

protocol LandmarkCoreDataManager {
    func fetchLandmarks(searchQuery: String?) -> [Landmark]
    func addLandmark(name: String, description: String, image: Data, coordinate: CoordinateModel, category: CategoryModel) -> Landmark?
//    func deleteCategory(category: Category)
//    func editCategory()
}

protocol CategoryCoreDataManager {
    func fetchCategories(searchQuery: String?) throws -> [Category]
    func fetchCategoryById(id: NSManagedObjectID) throws -> Category?
    func addCategory(name: String) -> Category
    func deleteCategory(category: Category)
    func editCategory()
}

protocol CoordinateCoreDataManager {
    func fetchCoordinateById(id: NSManagedObjectID) throws -> Coordinate?
    func addCoordinate(lat: Double, lng: Double) -> Coordinate

}
