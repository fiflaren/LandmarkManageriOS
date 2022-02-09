//
//  Date+.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

extension Date {
    func toLocalizedString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .short, timeStyle: .short)
    }
}
