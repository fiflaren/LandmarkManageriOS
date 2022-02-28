//
//  CategoryListView.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 09/02/2022.
//

import SwiftUI
import CoreData

struct LandmarkListView: View {
    @StateObject var landmarkViewModel: LandmarkListViewModel
    
    @State private var selection: NSManagedObjectID?
    @State private var searchText: String = ""
    @State private var showAddLandmarkModal: Bool = false
    
    var body: some View {
        Group {
            if landmarkViewModel.landmarks.count == 0 {
                Text("landmarkList_emptyText")
            } else {
                List {
                    ForEach(searchResults) { landmark in
                        let index = landmarkViewModel.landmarks.firstIndex(where: { $0.objectId == landmark.objectId })!
                        
                        NavigationLink(tag: landmark.objectId, selection: $selection) {
                            Text("test")
                        } label: {
                            LandmarkListRow(landmark: landmark)
                        }
                    
                    }
                }
                .searchable(text: $searchText, prompt: "landmarkList_searchPlaceholder".localized)
            }
        }
        .navigationTitle(Text("landmarkList_title", comment: "landmarkList_title"))
        .toolbar(content: {
            addButton
        })
        .alert(item: $landmarkViewModel.error) { error in
            Alert(title: Text("errorActionTitle"), message: Text(error.localizedDescription))
        }
        .sheet(isPresented: $showAddLandmarkModal) {
            AddLandmarkView(showModal: $showAddLandmarkModal)
        }
        .onChange(of: showAddLandmarkModal, perform: { newValue in
            landmarkViewModel.fetchLandmarks()
        })
    }
   
    private var addButton: some View {
        return AnyView(
            Button {
                showAddLandmarkModal.toggle()
            } label: {
                Image(systemName: "plus")
            }
        )
    }
    
    private var searchResults: [LandmarkModel] {
        if searchText.isEmpty {
            return landmarkViewModel.landmarks
        } else {
            return landmarkViewModel.landmarks.filter { $0.title.contains(searchText) }
        }
    }
}
