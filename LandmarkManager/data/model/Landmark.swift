//
//  Landmark.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation
import UIKit
import CoreData

struct LandmarkModel: Hashable, Identifiable {
    var id: Int
    var objectId: NSManagedObjectID
    var title: String
    var desc: String
    var image: UIImage
    var isFavorite: Bool
    var creationDate: Date
    var modificationDate: Date
    var category: CategoryModel?
    var location: CoordinateModel?
}
