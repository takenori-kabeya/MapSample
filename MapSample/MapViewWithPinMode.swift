//
//  MapViewWithPinMode.swift
//  MapSample
//
//  Created by Takenori Kabeya on 2023/05/27.
//

import SwiftUI
import MapKit


struct MapWithPinMode: View {
    @ObservedObject var locationManager: LocationManager
    
    @Binding var pinCoordinate: CLLocationCoordinate2D
    @Binding var pinDropped: Bool
    var pinName: String
    @Binding var isPinDraggingMode: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let items: [PinLocationInfo] = pinDropped ? [PinLocationInfo(location: pinCoordinate, name: pinName)] : []
            Map(coordinateRegion: $locationManager.region,
                interactionModes: isPinDraggingMode ? [] : . all,
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
            .gesture(drag(geometry))
        }
    }
    
    func drag(_ geometry: GeometryProxy) -> some Gesture {
        return DragGesture()
            .onChanged { gestureValue in
                if !isPinDraggingMode {
                    return
                }
                let frame = geometry.frame(in: .local)
                let midX = frame.midX
                let midY = frame.midY
                let relativeX = (gestureValue.location.x - midX) / frame.width
                let relativeY = (gestureValue.location.y - midY) / frame.height
                
                let distanceInDegreesX = locationManager.region.span.longitudeDelta * relativeX
                let distanceInDegreesY = locationManager.region.span.latitudeDelta * relativeY
                pinCoordinate = CLLocationCoordinate2D(latitude: locationManager.region.center.latitude - distanceInDegreesY,
                                                       longitude: locationManager.region.center.longitude + distanceInDegreesX)
                pinDropped = true
            }
            .onEnded { gestureValue in
                isPinDraggingMode = false
            }
    }
}

struct MapViewWithPinMode: View {
    @StateObject var locationManager = LocationManager()
    
    @Binding var pinCoordinate: CLLocationCoordinate2D
    @Binding var pinDropped: Bool
    var pinName: String
    @State var isPinDraggingMode: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPinDraggingMode = true
                }, label: {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                        Text(isPinDraggingMode ? "ピンドラッグ\nモード中" : "ピンドラッグ\nモードにします")
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
            MapWithPinMode(locationManager: locationManager, pinCoordinate: $pinCoordinate, pinDropped: $pinDropped, pinName: pinName, isPinDraggingMode: $isPinDraggingMode)
        }
    }
}


struct MapViewWithPinMode_PreviewHost: View {
    @State var pinCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State var pinDropped: Bool = false
    
    var body: some View {
        MapViewWithPinMode(pinCoordinate: $pinCoordinate, pinDropped: $pinDropped, pinName: "テスト")
    }
}

struct MapViewWithPinMode_Previews: PreviewProvider {
    static var previews: some View {
        MapViewWithPinMode_PreviewHost()
    }
}
