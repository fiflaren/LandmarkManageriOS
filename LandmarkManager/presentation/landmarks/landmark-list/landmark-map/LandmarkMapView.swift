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

    @State var showDetailsOnTap: Bool
    @State var mapLandmarks = [LandmarkModel]()
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.2276, longitude: 2.2137),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: mapLandmarks) { landmark in
            MapAnnotation(coordinate: landmark.mapLocation) {
                if showDetailsOnTap {
                    NavigationLink {
                        LandmarkDetails(landmark: landmark)
                    } label: {
                        LandmarkMapMarker()
                    }
                } else {
                    LandmarkMapMarker()
                }
            }
        }
        .onAppear {
            // if there is more than one landmark move the map so all are visible
            region = regionThatFitsTo(coordinates: mapLandmarks.map { $0.mapLocation })
            
        }
    }
    
    func regionThatFitsTo(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        for coordinate in coordinates {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, coordinate.longitude)
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, coordinate.latitude)
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, coordinate.longitude)
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, coordinate.latitude)
        }
        
        var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5
        region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5

        region.span.latitudeDelta = coordinates.count == 1 ? 4 : fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.4
        region.span.longitudeDelta = coordinates.count == 1 ? 4 : fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.4
        return region
    }
}

struct LandmarkMapView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkMapView(showDetailsOnTap: true)
    }
}

struct LandmarkMapMarker: View {
    var body: some View {
        Circle()
            .fill(Color.red)
            .frame(width: 20, height: 20)
    }
}
