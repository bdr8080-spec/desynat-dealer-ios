//
//  LocationManagerHandler.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import Foundation
import CoreLocation

enum LocationResult<T> {
    case success(T)
    case failure(Error)
}

class LocationManagerHandler: NSObject {
    
    // MARK: - Singleton
    public static let shared = LocationManagerHandler()
    
    // MARK: - Properties
    public var newLocation: CLLocation?
    private let locationManager: CLLocationManager
    private let geocoder = CLGeocoder()
    
    // Background location updates
    public var allowsBackgroundLocationUpdates: Bool = false {
        didSet {
            locationManager.pausesLocationUpdatesAutomatically = !allowsBackgroundLocationUpdates
            locationManager.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
        }
    }
    
    // MARK: - Init
    private override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    // MARK: - Authorization Status
    public var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    // MARK: - Request Permissions
    public func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Get Current Location
    public func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    // MARK: - Reverse Geocoding
    public func getStateAndCountry(from latitude: Double, longitude: Double, completion: @escaping (String?, String?, Error?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, nil, error)
            } else if let placemark = placemarks?.first {
                let state = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                completion(state, country, nil)
            } else {
                completion(nil, nil, nil)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManagerHandler: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) { }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.sorted(by: { $0.timestamp > $1.timestamp }).first {
            newLocation = location
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined, .restricted, .denied:
            break
        @unknown default:
            break
        }
    }
}
