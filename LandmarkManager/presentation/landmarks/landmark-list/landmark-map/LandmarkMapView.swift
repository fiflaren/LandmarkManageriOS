//
//  LandmarkMapView.swift
//  LandmarkManager
//
//  Created by Iuliu-Petru MACAVEI LT162 on 28/02/2022.
//

import SwiftUI
import MapKit
import CoreData

struct LandmarkMapView: View {
    @EnvironmentObject var landmarkViewModel: LandmarkListViewModel
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.2276, longitude: 2.2137),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: landmarkViewModel.mapLandmarks) { location in
            MapAnnotation(coordinate: location.coordinates) {
                NavigationLink {
                    Text("test")
                } label: {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}

struct LandmarkMapView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkMapView()
    }
}
