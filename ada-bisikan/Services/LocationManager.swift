//
//  LocationManagere.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 13/03/24.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    @Published var location : CLLocationCoordinate2D?
    @Published var isInADA: Bool = false
    @Published var distanceFromADA: Double = 0
    
    private var adaLatitude = -6.302139
    private var adaLongitude = 106.652444
    private var adaLocation = CLLocation(latitude: -6.302139, longitude: 106.652444)
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        
        let distance = adaLocation.distance(from: CLLocation(latitude: location?.latitude ?? 0, longitude: location?.longitude ?? 0))
        
        distanceFromADA = distance
        
        if distance < 100 {
            isInADA = true
        } else {
            isInADA = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // User has exited from ur region
        isInADA = true
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
}
