//
//  Category.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import CoreData

struct CategoryModel: Hashable, Identifiable {
    var id: Int
    var objectId: NSManagedObjectID
    var name: String
    var creationDate: Date
    var modificationDate: Date
}
