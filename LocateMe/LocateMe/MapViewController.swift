//
//  ViewController.swift
//  LocateMe
//
//  Created by David Fafinski on 03/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!
    fileprivate var locationManager = CLLocationManager()
    fileprivate var userLocation : MGLPointAnnotation?
    var _userLocationCoordinate : CLLocationCoordinate2D!
    fileprivate var userLocationCoordinate : CLLocationCoordinate2D {
        set {
            if(userLocation == nil) {
                userLocation = MGLPointAnnotation()
                userLocation!.coordinate = newValue
                mapView.addAnnotation(userLocation!)
            }
            mapView.setCenter(CLLocationCoordinate2D(latitude: newValue.latitude, longitude: newValue.longitude), zoomLevel: 9, animated: true)
            _userLocationCoordinate = newValue
        }
        get {
            return _userLocationCoordinate
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    override func viewDidAppear(_ animated: Bool) {
        centerMap()
    }

    @IBAction func geolocateUser() {
        centerMap()
    }

    private func askForLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

    private func centerMap() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                self.askForLocation()
            case .restricted, .denied:
                let alert = UIAlertController(title: "Attention", message: "Merci d'accéder à vos réglages afin d'autoriser le partage de la localisation.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            }
        } else {
            let alert = UIAlertController(title: "Attention", message: "Votre géolocalisation est indisponible, merci de l'activer depuis vos réglages", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userLocationCoordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("eerrrooor")
    }

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "pin")
        if(annotationImage == nil) {
            if let pinImage = UIImage(named: "pin") {
                annotationImage = MGLAnnotationImage(image: pinImage, reuseIdentifier: "pin")
            }
        }
        return annotationImage
    }



}

