//
//  ViewController.swift
//  LocateMe
//
//  Created by David Fafinski on 03/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var heightTableViewShownConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightTableViewHideConstraint: NSLayoutConstraint!
    private var placeList: [Place] = []
    fileprivate var locationManager = CLLocationManager()
    fileprivate var userLocation : MGLPointAnnotation?
    var _userLocationCoordinate : CLLocationCoordinate2D!
    fileprivate var userLocationCoordinate : CLLocationCoordinate2D {
        set {
            addPinAtCoordinate(latitude: newValue.latitude, longitude: newValue.longitude)
            centerMap(latitude: newValue.latitude, longitude: newValue.longitude)
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

    func addPinAtCoordinate(latitude: Double, longitude: Double) {
        if(userLocation == nil) {
            userLocation = MGLPointAnnotation()
        } else {
            mapView.removeAnnotation(userLocation!)
        }
        userLocation!.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(userLocation!)
    }

    override func viewDidAppear(_ animated: Bool) {
        centerMap(latitude: nil, longitude: nil)
    }

    @IBAction func geolocateUser() {
        centerMap(latitude: nil, longitude: nil)
    }

    private func askForLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

    private func centerMap(latitude: Double?, longitude: Double?) {
        if latitude == nil || longitude == nil {
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
        } else {
            mapView.setCenter(CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), zoomLevel: 9, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userLocationCoordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        locationManager.stopUpdatingLocation()
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        showSuggestionList()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector:#selector(searchForSuggestion), object: nil)
        self.perform(#selector(searchForSuggestion), with: nil, afterDelay: 0.5)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchForSuggestion()
        return true
    }

    @objc func searchForSuggestion() {
        dataManager.placeManager.searchPlaces(place: searchTextField.text!) { (places) in
            self.placeList = places
            self.suggestionTableView.reloadData()
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = suggestionTableView.dequeueReusableCell(withIdentifier: "placeCell")! as! SuggestionTableViewCell
        let place = placeList[indexPath.row]
        cell.suggestionLabel.text = place.printableAddress
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = placeList[indexPath.row]
        view.endEditing(true)
        searchTextField.text = place.printableAddress
        UIView.animate(withDuration: 0.3, animations: {
            self.heightTableViewHideConstraint.priority = .defaultHigh
            self.heightTableViewShownConstraint.priority = .defaultLow
        }) { (finished) in
            self.centerMap(latitude: place.latitude, longitude: place.longitude)
            self.addPinAtCoordinate(latitude: place.latitude!, longitude: place.longitude!)
        }
    }


    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    func showSuggestionList() {
        UIView.animate(withDuration: 0.3) {
            self.heightTableViewHideConstraint.priority = .defaultLow
            self.heightTableViewShownConstraint.priority = .defaultHigh
        }
    }



}

