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
    var locationCallBack:((String,String,Double,Double)->())?
    var locationManager = CLLocationManager()
    var currentLatLong = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var address = ""
    var pincode = ""
    var locality = ""
    var city = ""
    var state = ""
    var addressId = ""
    lazy private var viewModel = LocationViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.startUpdatingLocation()
        self.txtSearch.delegate = self
        self.googleMapSetup()
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
        locationCallBack?(address, locality, latitude ?? 0, longitude ?? 0)
            
//            viewModel.locationRequest { [weak self] in
//                self?.navigationController?.popViewController(animated: true)
//            }
        self.navigationController?.popViewController(animated: true)
    }
}

extension LocationViewController: CLLocationManagerDelegate,GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 12.0)
        self.viewMap.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        self.latitude = cameraPosition.target.latitude
        self.longitude = cameraPosition.target.longitude
        reverseGeocodeCoordinate(cameraPosition.target)
    }
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        currentLatLong = coordinate
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:coordinate.latitude, longitude: coordinate.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                var addressGlobal : String = ""
                var addressCity : String = ""
                if pm.name != nil{
                    addressString = addressString + pm.name! + ", "
                    addressGlobal = addressGlobal + pm.name! + ", "
                }
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                    addressGlobal = addressGlobal + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                    addressGlobal = addressGlobal + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressCity = addressCity + pm.locality!
                    addressString = addressString + pm.locality! + " "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                    addressGlobal = addressGlobal + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                    addressGlobal = addressGlobal + pm.postalCode! + " "
                    // self.currentPinCode = pm.postalCode ?? ""
                }
                self.txtSearch.text = addressString
                self.city = pm.locality ?? ""
                self.pincode = pm.postalCode ?? ""
                self.locality = pm.subLocality ?? ""
                self.state = pm.administrativeArea ?? ""
                self.address = addressString
                self.lblLocation.text = addressString
            }
        })
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
