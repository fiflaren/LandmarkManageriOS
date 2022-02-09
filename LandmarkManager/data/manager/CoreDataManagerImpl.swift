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
    
    func fetchCategories(searchQuery: String? = nil) -> [Category] {
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
            // TODO : replace fatal error with proper error handling
            fatalError(error.localizedDescription)
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
    
}
