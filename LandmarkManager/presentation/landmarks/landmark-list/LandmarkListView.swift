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
    @State private var selectedTabIndex: Int = 0
    
    var body: some View {
        Group {
            if landmarkViewModel.isLoading {
                ProgressView()
            } else if landmarkViewModel.isLoading == false && landmarkViewModel.landmarks.count == 0 {
                Text("landmarkList_emptyText")
            } else {
//                Picker("What is your favorite color?", selection: $selectedTabIndex) {
//                    Text("Liste").tag(0)
//                    Text("Carte").tag(1)
//                }
//                .pickerStyle(.segmented)
//                .padding(.horizontal)
                
                if selectedTabIndex == 0 {
                    List {
                        ForEach(searchResults) { landmark in
                            let index = landmarkViewModel.landmarks.firstIndex(where: { $0.objectId == landmark.objectId })!
                            
                            NavigationLink(tag: landmark.objectId, selection: $selection) {
                                LandmarkDetails(landmark: landmark)
                            } label: {
                                LandmarkListRow(landmark: landmark)
                            }
                        
                        }
                    }
                    .searchable(text: $searchText, prompt: "landmarkList_searchPlaceholder".localized)
                } else {
                    LandmarkMapView(showDetailsOnTap: true, mapLandmarks: landmarkViewModel.landmarks)
                }
                
            }
        }
        .navigationTitle(Text("landmarkList_title", comment: "landmarkList_title"))
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Section {
                        Button(action: {
                            selectedTabIndex = selectedTabIndex == 0 ? 1 : 0
                        }) {
                            Label(selectedTabIndex == 0 ? "Carte" : "Liste", systemImage: selectedTabIndex == 0 ? "map" : "list.bullet")
                        }
                    }
                    
                    Section {
                        Picker(selection: $landmarkViewModel.sortBy, label: Text("Trier par")) {
                            Text("Title").tag(0)
                            Text("Date").tag(1)
                            Text("Location").tag(2)
                        }
                    }
                }
                label: {
                    Label("More", systemImage: "ellipsis.circle")
                }
                
                addButton
            }
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
        .onChange(of: landmarkViewModel.sortBy, perform: { newValue in
            landmarkViewModel.fetchLandmarks()
        })
        .onAppear {
            landmarkViewModel.loadLandmarks()
        }
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
