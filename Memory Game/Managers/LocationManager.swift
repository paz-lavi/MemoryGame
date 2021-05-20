//
//  LocationManager.swift
//  Memory Game
//
//  Created by Paz Lavi  on 30/04/2021.
//

import Foundation
import CoreLocation

class LocationManager :NSObject{
    static let shared = LocationManager()
    var lastKnownLocation: LatLng?
    private var locationManager:CLLocationManager
    
    var locationGranted: Bool?
    //Initializer access level change now
    private override init(){
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        
        
        
    }
    
    
    
    
    func requestAuthorization(){
        var status : CLAuthorizationStatus!
        if #available(iOS 14.0, *){
            status = CLLocationManager().authorizationStatus
        }else{
            status = CLLocationManager.authorizationStatus()
            
        }
        switch status {
        case .authorizedAlways,.authorizedWhenInUse :
            locationManager.requestLocation()
        // Handle case
        case .denied, .restricted:
            lastKnownLocation = LatLng(lat: 40.754910, lng: -73.994102) //Times Squre as def
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        default: break
            
        }
    }
    func requestForLocation() -> LatLng?{
        locationManager.requestLocation()
        locationGranted = true
        return lastKnownLocation ?? nil
    }
    
    
}

//MARK:- Get the location
extension LocationManager : CLLocationManagerDelegate{
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestAuthorization()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            lastKnownLocation = LatLng(lat: latitude, lng: longitude)
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        NSLog("Error in location: \(error)")
    }
    
    
    
    
}
