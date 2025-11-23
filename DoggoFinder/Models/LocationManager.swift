//
//  LocationManager.swift
//  DoggoFinder
//
//  Created by Studente on 20/07/24.
//

import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var permission: String = "notDetermined"
    
    var manager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    func checkLocationAuthorization() {
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            permission = "notDetermined"
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            permission = "restricted"
            
        case .denied:
            permission = "denied"
            
        case .authorizedAlways:
            permission = "authorizedAlways"
            
        case .authorizedWhenInUse:
            permission = "authorizedWhenInUse"
            lastKnownLocation = manager.location?.coordinate
            
        @unknown default:
            permission = "serviceDisabled"
        
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
    func getCityAndProvince(latitude: Double, longitude: Double, completion: @escaping (String?, String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            if let placemark = placemarks?.first {
                let city = placemark.locality
                let province = placemark.subAdministrativeArea
                completion(city, province)
            } else {
                completion(nil, nil)
            }
        }
    }
}
