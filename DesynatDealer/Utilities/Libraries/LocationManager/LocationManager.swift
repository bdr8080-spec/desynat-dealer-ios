//
//  locationManager.swift
//  Kawader
//
//  Created by  on 12/03/20.
//  Copyright © 2020 . All rights reserved.

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    static let sharedInstance = LocationManager()
    
    var location: CLLocationCoordinate2D?
    var currentLocation = ""
    var callBackGetCurrentLoc: ((_ location: CLLocationCoordinate2D, _ add: String?) -> ())?
    var country = ""
    var getPickCity = ""
    
    private override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Allow setting external delegate
    func setDelegate(_ delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
//    func startUpdatingLocation() {
//        if #available(iOS 14.0, *) {
//            switch locationManager.authorizationStatus {
//            case .notDetermined:
//                locationManager.requestWhenInUseAuthorization()
//            case .authorizedWhenInUse, .authorizedAlways:
//                locationManager.startUpdatingLocation()
//            case .denied, .restricted:
//                print("❌ Location permission denied")
//            @unknown default:
//                break
//            }
//        } else {
//            switch CLLocationManager.authorizationStatus() {
//            case .notDetermined:
//                locationManager.requestWhenInUseAuthorization()
//            case .authorizedWhenInUse, .authorizedAlways:
//                locationManager.startUpdatingLocation()
//            default:
//                break
//            }
//        }
//    }
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }
        self.location = loc.coordinate
        reverseGeocodeCoordinate(loc.coordinate) { address in
            self.currentLocation = address
            self.callBackGetCurrentLoc?(loc.coordinate, address)
        }
        manager.stopUpdatingLocation()
    }
    
    public func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: @escaping (_ address: String) -> Void) {
        let ceo = CLGeocoder()
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        ceo.reverseGeocodeLocation(loc) { placemarks, error in
            guard error == nil, let pm = placemarks?.first else {
                completion("")
                return
            }
            var addressString = ""
            if let name = pm.name { addressString += name + ", " }
            if let locality = pm.locality { addressString += locality + ", " }
            if let country = pm.country { addressString += country }
            completion(addressString)
            self.country = pm.country ?? ""
            self.getPickCity = pm.locality ?? ""
        }
    }
    
    func getCurrentLocationCode() -> ADCountry {
        var countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? "US"
        
        var CallingCodes = { () -> [[String: String]] in
            let resourceBundle = Bundle(for: ADCountryPicker.classForCoder())
            guard let path = resourceBundle.path(forResource: "CallingCodes", ofType: "plist") else { return [] }
            return NSArray(contentsOfFile: path) as! [[String: String]]
        }()
        
        let locale = Locale.current
        let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
        let countryData = CallingCodes.filter { $0["code"] == countryCode }
        let country: ADCountry
        
        if countryData.count > 0, let dialCode = countryData[0]["dial_code"] {
            return ADCountry(name: displayName!, code: countryCode, dialCode: dialCode)
        } else {
            return ADCountry(name: displayName!, code: countryCode)
        }
    }
}
