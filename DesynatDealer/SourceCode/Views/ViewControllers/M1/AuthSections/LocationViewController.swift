//
//  LocationViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var lblLocation: UILabel!
    
    var locationFor = ""
    var currentLocation:String?
    var latitude:Double?
    var longitude:Double?
    let ZOOM_LEVEL_HIGH:Float = 16.0
    var locationCallBack: ((String, String, String, String, String, String, Double, Double) -> ())?
        
//    var locationManager = CLLocationManager()
    var currentLatLong = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var locationManager = CLLocationManager()
        var address = ""
        var locality = ""
        var city = ""
        var state = ""
        var country = ""
        var pincode = ""
//        var latitude: Double?
//        var longitude: Double?
    lazy private var viewModel = LocationViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.startUpdatingLocation()
        self.txtSearch.delegate = self
        self.googleMapSetup()
        
        locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
    }

    func googleMapSetup() {
        self.latitude = LocationManager.sharedInstance.location?.latitude ?? 0.0
        self.longitude = LocationManager.sharedInstance.location?.longitude ?? 0.0
        self.currentLocation =  LocationManager.sharedInstance.currentLocation
        viewMap.isMyLocationEnabled = false
        let camera = GMSCameraPosition.camera(withLatitude: latitude ?? 0.0, longitude: longitude ?? 0.0, zoom: 12)
        self.viewMap.camera = camera
        self.viewMap.delegate = self
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCurrentLocation(_ sender: Any) {
        self.latitude = LocationManager.sharedInstance.location?.latitude ?? 0.0
        self.longitude = LocationManager.sharedInstance.location?.longitude ?? 0.0
        let camera = GMSCameraPosition.camera(withLatitude: latitude ?? 0.0, longitude: longitude ?? 0.0, zoom: 12)
        self.viewMap.camera = camera
    }
    
    @IBAction func btnSave(_ sender: Any) {
//        locationCallBack?(address, locality, latitude ?? 0, longitude ?? 0)
            
//            viewModel.locationRequest { [weak self] in
//                self?.navigationController?.popViewController(animated: true)
//            }
//        self.navigationController?.popViewController(animated: true)
        
        locationCallBack?(
                    address,     // Full address
                    locality,    // Area or sublocality
                    city,        // City
                    state,       // State
                    country,     // Country
                    pincode,     // Pincode
                    latitude ?? 0,
                    longitude ?? 0
                )
                self.navigationController?.popViewController(animated: true)
            
    }
}

extension LocationViewController: CLLocationManagerDelegate,GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 12.0)
        self.viewMap.animate(to: camera)
        self.latitude = location?.coordinate.latitude
        self.longitude = location?.coordinate.longitude
        self.locationManager.stopUpdatingLocation()
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            guard let location = locations.last else { return }
//            latitude = location.coordinate.latitude
//            longitude = location.coordinate.longitude
//            reverseGeocodeCoordinate(location.coordinate)
//            
//            // Center map on current location
//            let region = MKCoordinateRegion(center: location.coordinate,
//                                            latitudinalMeters: 500,
//                                            longitudinalMeters: 500)
//        viewMap.setRegion(region, animated: true)
//        }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        self.latitude = cameraPosition.target.latitude
        self.longitude = cameraPosition.target.longitude
        reverseGeocodeCoordinate(cameraPosition.target)
    }
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard error == nil else { return }
                guard let pm = placemarks?.first else { return }
                
                var addressString = ""
                
                if let name = pm.name {
                    addressString += name + ", "
                }
                if let subLocality = pm.subLocality {
                    addressString += subLocality + ", "
                    self.locality = subLocality
                }
                if let locality = pm.locality {
                    addressString += locality + ", "
                    self.city = locality
                }
                if let state = pm.administrativeArea {
                    addressString += state + ", "
                    self.state = state
                }
                if let country = pm.country {
                    addressString += country + ", "
                    self.country = country
                }
                if let postalCode = pm.postalCode {
                    addressString += postalCode
                    self.pincode = postalCode
                }
                
                self.address = addressString
                self.txtSearch.text = addressString
                self.lblLocation.text = addressString
            }
        }
}
extension LocationViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewMap.moveCamera(GMSCameraUpdate.setTarget(CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), zoom: ZOOM_LEVEL_HIGH))
        dismiss(animated: true, completion: nil)
        self.txtSearch.text = place.formattedAddress
    
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtSearch{
            self.txtSearch.resignFirstResponder()
            let acController = GMSAutocompleteViewController()
            acController.delegate = self as GMSAutocompleteViewControllerDelegate
            present(acController, animated: true, completion: nil)
            return
        }
    }
}
