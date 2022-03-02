//
//  ErrorDisplayWrapper.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

enum ErrorDisplayWrapper: Error, LocalizedError, Identifiable {
    case specificError(Error)
    
    var id: String {
        self.localizedDescription
    }
    
    var errorDescription: String? {
        NSLocalizedString(localizedDescription, comment: localizedDescription)
    }
}
