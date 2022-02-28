//
//  CoreDataManagerImpl.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import CoreData
import UIKit

class CoreDataManagerImpl: CoreDataManager {

    static let shared: CoreDataManager = CoreDataManagerImpl()
    
    private let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "LandmarkManager")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // TODO : replace fatal error with proper error handling
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK: - CoreData Methods
    private func saveContext() {
        do {
            try container.viewContext.save()
        } catch {
            // TODO : replace fatal error with proper error handling
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

// MARK: - Categories

extension CoreDataManagerImpl {
    func fetchCategories(searchQuery: String? = nil) throws -> [Category] {
        let fetchRequest = Category.fetchRequest()
        
        let sortDescription = NSSortDescriptor(keyPath: \Category.name, ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            let predicate = NSPredicate(format: "%K contains[cd] %@", argumentArray: [#keyPath(Category.name), searchQuery])
            fetchRequest.predicate = predicate
        }
        
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            throw CategoryError.failedFetchingFromDb
        }
    }
    
    func fetchCategoryById(id: NSManagedObjectID) throws -> Category? {
        do {
            guard let result = try container.viewContext.existingObject(with: id) as? Category else {
                return nil
            }
            return result
        } catch {
            throw CategoryError.notFound
        }
    }
    
    func addCategory(name: String) -> Category {
        let date = Date()
        
        let category = Category(context: container.viewContext)
        category.name = name
        category.creationDate = date
        category.modificationDate = date
        
        saveContext()
        
        return category
    }
    
    func deleteCategory(category: Category) {
        container.viewContext.delete(category)
        saveContext()
    }
    
    func editCategory() {
        saveContext()
    }
}

// MARK: - Landmarks

extension CoreDataManagerImpl {
    func fetchLandmarks(searchQuery: String?) -> [Landmark] {
        let fetchRequest = Landmark.fetchRequest()
        
        let sortDescription = NSSortDescriptor(keyPath: \Landmark.title, ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            let predicate = NSPredicate(format: "%K contains[cd] %@", argumentArray: [#keyPath(Landmark.title), searchQuery])
            fetchRequest.predicate = predicate
        }
        
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            // TODO : replace fatal error with proper error handling
            fatalError(error.localizedDescription)
        }
    }

    func addLandmark(name: String, description: String, image: Data, coordinate: CoordinateModel, category: CategoryModel) -> Landmark? {
        let date = Date()
        
        var cat: Category
        let coord: Coordinate = addCoordinate(lat: coordinate.lat, lng: coordinate.lng)
        
        do {
            guard let categoryWithId = try fetchCategoryById(id: category.objectId) else {
                return nil
            }
            
            cat = categoryWithId
        } catch {
            return nil
        }
        
        
        let landmark = Landmark(context: container.viewContext)
        landmark.title = name
        landmark.desc = description
        landmark.creationDate = date
        landmark.modificationDate = date
        landmark.category = cat
        landmark.coordinate = coord
        landmark.image = image
        
        saveContext()
        
        return landmark
    }
}

// MARK: - Coordinates

extension CoreDataManagerImpl {
    func fetchCoordinateById(id: NSManagedObjectID) throws -> Coordinate? {
        do {
            guard let result = try container.viewContext.existingObject(with: id) as? Coordinate else {
                return nil
            }
            return result
        } catch {
            // TODO : replace with coordinate error
            throw CategoryError.notFound
        }
    }
    
    func addCoordinate(lat: Double, lng: Double) -> Coordinate {
        let coordinate = Coordinate(context: container.viewContext)
        coordinate.latitude = lat
        coordinate.longitude = lng
        
        saveContext()
        
        return coordinate
    }
}
