//
//  CategoryListViewModel.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import Foundation

@MainActor class CategoryListViewModel: ObservableObject {
   
    @Published var categories = [Category]()
    @Published var isLoading: Bool = true
    @Published var selectedCategory: Category?
    @Published var error: String?
    
    private var categoryRepository = CategoryRepository.shared
    
    init() {
        fetchCategories()
    }
    
    func fetchCategories(searchQuery: String? = nil) {
        self.categories = categoryRepository.categories
    }
    
    func addCategory(name: String) {
        categoryRepository.addCategory(name: name)
        fetchCategories()
    }
}

