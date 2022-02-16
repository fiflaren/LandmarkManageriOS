//
//  LandmarkManagerApp.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import SwiftUI

@main
struct LandmarkManagerApp: App {
    @State private var finishedLoading: Bool = false
    
    private func displayMainContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                self.finishedLoading.toggle()
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if finishedLoading {
                CategoryListView()
                
            } else {
                SplashScreenView()
                    .onAppear {
                        displayMainContent()
                    }
            }
        }
    }
}
