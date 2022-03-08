//
//  ListSortingProperty.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 08/03/2022.
//

import Foundation

enum ListSortingProperty: Int, CaseIterable, Identifiable {
    case name = 0
    case creationDate = 1
    case modificationDate = 2

    var id: Int {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .name:
            return "listSortingTitle".localized
        case .creationDate:
            return "listSortingCreationDate".localized
        case .modificationDate:
            return "listSortingModificationDate".localized
        }
    }
}
