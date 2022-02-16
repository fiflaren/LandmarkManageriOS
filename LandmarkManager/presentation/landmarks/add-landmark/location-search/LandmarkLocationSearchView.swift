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
    
    @State var defaultRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
    var body: some View {
        
        VStack() {
            ZStack(alignment: .center) {
                MapView()
                    .environmentObject(mapViewModel)
                
                Image(systemName: "mappin.and.ellipse")
                    .tint(.accentColor)
                
                VStack {
                    Spacer()
                    
                    VStack {
                        
                        Button { mapViewModel.resetToUserLocation() } label: {
                            Image(systemName: "location.fill")
                                .font(.title2)
                                .padding(5)
                                .background(alignment: .center, content: {
                                    Circle().fill(.regularMaterial)
                                })
                                
                                .clipShape(Circle())
                        }
                        
                        Button { mapViewModel.updateMapType() } label: {
                            Image(systemName: mapViewModel.mapType == .standard ? "network" : "map")
                                .font(.title2)
                                .padding(5)
                                .background(alignment: .center, content: {
                                    Circle().fill(.regularMaterial)
                                })
                                
                                .clipShape(Circle())
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
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
            
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .padding(.horizontal, 2)
                Text("Chercher par adresse")
            }
            .padding(5)
            .padding(.bottom, 10)
        }
        .navigationTitle("Choisir un lieu")
        .onAppear {
            LocationManager.shared.setLocationManagerDelegate(delegate: mapViewModel)
            LocationManager.shared.requestLocationPermission()

        }        
    }
}

struct LandmarkLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkLocationSearchView()
    }
}
