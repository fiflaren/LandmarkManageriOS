//
//  Mapper.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

class Mapper {
    static let shared = Mapper()
    
    private init() {
        
    }
    
    func mapCategoryDbEntityToModel(entity: Category, id: Int) -> CategoryModel {
        return CategoryModel(
            id: id,
            objectId: entity.objectID,
            name: entity.name!,
            creationDate: entity.creationDate!,
            modificationDate: entity.modificationDate!
        )
    }
}
