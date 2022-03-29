//
//  Color+.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 29/03/2022.
//

import Foundation
import SwiftUI

extension Color {
    static var imageBlackOverlayGradient: Array<Color> {
        return [
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.1),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 0.3),
            Color(red: 37/255, green: 37/255, blue: 37/255, opacity: 1.0),
        ]
    }
}
