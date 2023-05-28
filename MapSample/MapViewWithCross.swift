//
//  MapViewWithCross.swift
//  MapSample
//
//  Created by Takenori Kabeya on 2023/05/27.
//

import SwiftUI
import MapKit

struct PinLocationInfo: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    let name: String
    
    init(id: UUID = UUID(), location: CLLocationCoordinate2D, name: String) {
        self.id = id
        self.location = location
        self.name = name
    }
}


struct MapWithCross: View {
    @ObservedObject var locationManager: LocationManager
    
    @Binding var pinCoordinate: CLLocationCoordinate2D
    @Binding var pinDropped: Bool
    @State var region: MKCoordinateRegion = MKCoordinateRegion()
    var pinName: String
    
    var body: some View {
        ZStack {
            let items: [PinLocationInfo] = pinDropped ? [PinLocationInfo(location: pinCoordinate, name: pinName)] : []
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: nil,
                annotationItems: items,
                annotationContent: { place in
                MapAnnotation(coordinate: place.location, anchorPoint: CGPoint(x: 0.0, y: 0.5)) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .scaleEffect(0.8)
                        Text(place.name)
                            .padding(.leading, -8)
                    }
                    .foregroundColor(.purple)
                    .offset(x: -12)
                }
            })
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: 1)
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(height: 1)
        }
        .sync($locationManager.region, with: $region)
    }
}
struct MapViewWithCross: View {
    @StateObject var locationManager = LocationManager()
    
    @Binding var pinCoordinate: CLLocationCoordinate2D
    @Binding var pinDropped: Bool
    var pinName: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    pinCoordinate = locationManager.region.center
                    pinDropped = true
                }, label: {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                        Text(pinDropped ? "地図の中心に\nピンを再設定" : "地図の中心に\nピンを設定")
                            .font(.caption2)
                            .frame(width: 120, height: 50)
                    }
                })
                .buttonStyle(.bordered)
                .scaleEffect(0.8)
                Button(action: {
                    locationManager.startUpdatingLocation()
                }, label: {
                    HStack {
                        Image(systemName: "location.circle.fill")
                        Text("現在地を表示")
                            .font(.caption2)
                            .frame(width: 120, height: 50)
                    }
                })
                .buttonStyle(.bordered)
                .scaleEffect(0.8)
            }
            MapWithCross(locationManager: locationManager, pinCoordinate: $pinCoordinate, pinDropped: $pinDropped, pinName: pinName)
        }
    }

}

struct MapViewWithCross_PreviewHost: View {
    @State var pinCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State var pinDropped: Bool = false
    
    var body: some View {
        MapViewWithCross(pinCoordinate: $pinCoordinate, pinDropped: $pinDropped, pinName: "テスト")
    }
}

struct MapViewWithCross_Previews: PreviewProvider {
    static var previews: some View {
        MapViewWithCross_PreviewHost()
    }
}
