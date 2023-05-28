//
//  LocationManager.swift
//  MapSample
//
//  Created by Takenori Kabeya on 2023/05/27.
//

import Foundation
import MapKit
import SwiftUI



class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var distanceFilter: CLLocationDistance = 2.0
    var regionMeters: CLLocationDistance = 1000.0
    var updateOnce: Bool = true
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = distanceFilter
        
        self.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            locations.last.map {
                let center = CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                self.region = MKCoordinateRegion(center: center, latitudinalMeters: self.regionMeters, longitudinalMeters: self.regionMeters)
            }
            if self.updateOnce {
                self.stopUpdatingLocation()
            }
        }
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}



extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return (lhs.center.latitude == rhs.center.latitude &&
                lhs.center.longitude == rhs.center.longitude &&
                lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
                lhs.span.longitudeDelta == rhs.span.longitudeDelta)
    }
}

extension View {
    func sync<T: Equatable>(_ published: Binding<T>, with binding: Binding<T>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                if binding.wrappedValue != published {
                    binding.wrappedValue = published
                }
            }
            .onChange(of: binding.wrappedValue) { binding in
                if published.wrappedValue != binding {
                    published.wrappedValue = binding
                }
            }
    }
}

