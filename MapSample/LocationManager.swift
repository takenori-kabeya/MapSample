//
//  LocationManager.swift
//  MapSample
//
//  Created by Takenori Kabeya on 2023/05/27.
//

import Foundation
import MapKit


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var distanceFilter: CLLocationDistance = 2.0
    var regionMeters: CLLocationDistance = 1000.0
    var updateOnce: Bool = true
    
    //@Published var regionInfo: RegionInfo = RegionInfo()
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
        locations.last.map {
            let center = CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
            //regionInfo.region = MKCoordinateRegion(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
            self.region = MKCoordinateRegion(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
        }
        if updateOnce {
            self.stopUpdatingLocation()
        }
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}
