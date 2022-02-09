//
//  CategoryListView.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import SwiftUI
import CoreData

struct CategoryListView: View {
    @StateObject var categoryViewModel: CategoryListViewModel = CategoryListViewModel()
    
    @State var selection: NSManagedObjectID?
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchResults) { category in
                    let index = categoryViewModel.categories.firstIndex(where: { $0.objectID == category.objectID })!
                    
                    NavigationLink(tag: category.objectID, selection: $selection) {
                        Text("test")
                    } label: {
                        CategoryListRow(category: category)
                    }
                    //                .swipeActions {
                    //                    Button {
                    //                        withAnimation {
                    //                            articleViewModel.articles[index].likes += 1
                    //                        }
                    //                    } label: {
                    //                        Label {
                    //                            Text("Favorite", comment: "Swipe action button in article list")
                    //                        } icon: {
                    //                            Image(systemName: "heart")
                    //                        }
                    //                    }
                    //                    .tint(.accentColor)
                    //                }
                }
            }
            .navigationTitle(Text("Catégories", comment: "Catégories"))
            //        .accessibilityRotor("Catégories", entries: searchResults, entryLabel: \.name)
            .toolbar {
                Button {
                    showAlertWithTextView() { categoryName in
                        categoryViewModel.addCategory(name: categoryName)
                    }
                } label: {
                    Image(systemName: "plus")
                }
                
            }
            .searchable(text: $searchText, prompt: "Trouver une catégorie…")
            
        }
        
    }
    
    var searchResults: [Category] {
        if searchText.isEmpty {
            return categoryViewModel.categories
        } else {
            return categoryViewModel.categories
            //            return categoryViewModel.categories.filter { $0.name.contains(searchText) }
        }
    }
    
    
}

extension CategoryListView {
    private func showAlertWithTextView(finished: @escaping (String) -> ()) {
        let alert = UIAlertController(title: "newTask_title".localized,
                                      message: "newTask_subTitle".localized,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "newTask_textFieldPlaceholder".localized
        }
        
        let cancelAction = UIAlertAction(title: "newTask_cancelActionTitle".localized, style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "newTask_saveActionTitle".localized, style: .default) { _ in
            guard let textField = alert.textFields?.first else {
                return
            }

            finished(textField.text!)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        showAlert(alert: alert)
    }

    func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }

    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive}
        .compactMap {$0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
    }

    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
}
