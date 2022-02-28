//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

@MainActor class LandmarkMapViewModel: ObservableObject {
   
    @Published var landmarks = [LandmarkModel]()
    @Published var isLoading: Bool = true
    @Published var selectedLandmark: LandmarkModel?
    @Published var error: ErrorDisplayWrapper?
    
    init() {
    }

}

