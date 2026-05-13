//
//  LocationPermissionViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.

import UIKit
import CoreLocation

class LocationPermissionViewController: UIViewController {
    
    var onPermissionCompletion: (() -> Void)?
    private let locationManager = LocationManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.setDelegate(self)
    }
    
    @IBAction func denyDidTapped(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            self?.onPermissionCompletion?()
        }
    }
    
    @IBAction func allowDidTapped(_ sender: Any) {
//        locationManager.startUpdatingLocation()
        self.dismiss(animated: true) { [weak self] in
            self?.onPermissionCompletion?()
        }
    }
    
    func navigateToNextScreen() {
        self.dismiss(animated: true) { [weak self] in
            self?.onPermissionCompletion?()
        }
    }
    
}

extension LocationPermissionViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
//                print("✅ Location access granted")
                locationManager.callBackGetCurrentLoc = { loc, address in
                    print("📍 User location: \(address ?? "")")
                }
                navigateToNextScreen()
            case .denied, .restricted:
//                print("❌ Location access denied")
                navigateToNextScreen()
            case .notDetermined:
                print("ℹ️ Waiting for user decision…")
            @unknown default:
                break
            }
        }
    }
}
