//
//  LandmarkLocationSearchView.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 16/02/2022.
//

import SwiftUI
import MapKit

struct LandmarkLocationSearchView: View {
    @ObservedObject var addLandmarkViewModel: AddLandmarkViewModel = AddLandmarkViewModel()
    
    @StateObject var mapViewModel = LandmarkLocationMapViewModel()
    
    var body: some View {
        
        VStack() {
            
            ZStack(alignment: .center) {
                MapView()
                    .environmentObject(mapViewModel)
                
                Image(systemName: "mappin.and.ellipse")
                    .tint(.accentColor)
                
                VStack {
                    
                    
                    VStack(spacing: 5) {
                        // search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .padding(.horizontal, 2)
                                .foregroundColor(.gray)
                            
                            TextField("Chercher par nom...", text: $mapViewModel.searchQuery)
                        }
                        .padding(8)
                        .background(.regularMaterial)
                        .cornerRadius(5)
                        
                        // search results
                        if !mapViewModel.searchResults.isEmpty && mapViewModel.searchQuery != "" {
                            ScrollView {
                                VStack(spacing: 15) {
                                    ForEach(mapViewModel.searchResults) { result in
                                        HStack {
                                            Text(result.title)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.leading)
                                            
                                        }.onTapGesture {
                                            mapViewModel.selectSearchResult(location: result)
                                        }
                                        
                                        Divider()
                                    }
                                }
                                .padding(.top)
                            }
                            .background(.regularMaterial)
                            .cornerRadius(5)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    VStack {
                        
                        Button { mapViewModel.updateMapType() } label: {
                            Image(systemName: mapViewModel.mapType == .standard ? "network" : "map")
                                .font(.title2)
                                .padding(6)
                                .background(alignment: .center, content: {
                                    Circle().fill(.white)
                                        .opacity(0.8)
                                    
                                })
                                .clipShape(Circle())
                        }
                        
                        Spacer().frame(height: 50)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(10)
                }
            }
            
            
            Button(action: {}) {
                Text("Choisir ce lieu")
            }
            .tint(.accentColor)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 5))
            .controlSize(.large)
            .padding(5)
            
        }
        .navigationTitle("Choisir un lieu")
        .onAppear {
            LocationManager.shared.setLocationManagerDelegate(delegate: mapViewModel)
            LocationManager.shared.requestLocationPermission()
        }
        .onChange(of: mapViewModel.searchQuery) { value in
            let delay = 0.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                mapViewModel.searchWithQuery()
            }
        }
    }
}

struct LandmarkLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkLocationSearchView()
    }
}
