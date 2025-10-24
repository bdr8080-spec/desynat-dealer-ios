//
//  locationManager.swift
//  Kawader
//
//  Created by  on 12/03/20.
//  Copyright © 2020 . All rights reserved.

import Foundation
import CoreLocation

class LocationManager:NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    open var location:CLLocationCoordinate2D?
    open var currentLocation = ""
    open var callBackGetCurrentLoc:((_ location:CLLocationCoordinate2D, _ add:String?)->())?
    open var country = ""
    open var getPickCity = ""
    
    static var sharedInstance = LocationManager()
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first?.coordinate {
            self.location = CLLocationCoordinate2D(latitude: loc.latitude,
                                                   longitude: loc.longitude)
        }
        printInConsole("latitude \(String(describing: locations.first)),longitude \(String(describing: locations.first))")
        
        if let location {
            self.reverseGeocodeCoordinate(location) { add in
                self.currentLocation = add
                self.callBackGetCurrentLoc?(location, self.currentLocation)
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    public func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion:@escaping(_ address:String) -> Void) {
        
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:coordinate.latitude, longitude: coordinate.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            guard let pm = placemarks as? [CLPlacemark] else {return}
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.name != nil {
                    addressString = addressString + pm.name! + ", "
                }
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
//                if pm.thoroughfare != nil {
//                    addressString = addressString + pm.thoroughfare! + ", "
//                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + " "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                self.country = pm.country ?? ""
                completion(addressString)
                self.getPickCity = pm.locality ?? ""
                
                print("subLocality\(pm.subLocality ?? "")")
                print("pm.thoroughfare\(pm.thoroughfare ?? "")")
                print("pm.locality\(pm.locality ?? "")")
                print("pm.country\(pm.country ?? "")")
                print("pm.postalCode\(pm.postalCode ?? "")")
                print("pm.name\(pm.name)")
                print("pm.subThoroughfare\(pm.subThoroughfare ?? "")")
                print("pm.administrativeArea\(pm.administrativeArea ?? "")")
                print("pm.subAdministrativeArea\(pm.subAdministrativeArea ?? "")")
                
            }
        })
    }
    
//    func getCurrentLocationCode() -> ADCountry {
//        var countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? "US"
//        
//        var CallingCodes = { () -> [[String: String]] in
//            let resourceBundle = Bundle(for: ADCountryPicker.classForCoder())
//            guard let path = resourceBundle.path(forResource: "CallingCodes", ofType: "plist") else { return [] }
//            return NSArray(contentsOfFile: path) as! [[String: String]]
//        }()
//        
//        let locale = Locale.current
//        let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
//        let countryData = CallingCodes.filter { $0["code"] == countryCode }
//        let country: ADCountry
//        
//        if countryData.count > 0, let dialCode = countryData[0]["dial_code"] {
//            return ADCountry(name: displayName!, code: countryCode, dialCode: dialCode)
//        } else {
//            return ADCountry(name: displayName!, code: countryCode)
//        }
//    }
}
