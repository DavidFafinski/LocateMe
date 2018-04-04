//
//  ViewController.swift
//  LocateMe
//
//  Created by David Fafinski on 03/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var backViewButton: UIView!
    @IBOutlet weak var centerPin: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var suggestionView: UIView!
    @IBOutlet weak var heightTableViewShownConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightTableViewHideConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftSearchWithBackConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftSearchWithoutBackConstraint: NSLayoutConstraint!
    fileprivate var _placeList: [Place] = []
    fileprivate var _locationManager = CLLocationManager()
    fileprivate var _mapViewContainer: MapViewContainer!

    override func viewDidLoad() {
        super.viewDidLoad()
        _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        backViewButton.layer.borderColor = #colorLiteral(red: 0.6990365933, green: 0.6990365933, blue: 0.6990365933, alpha: 1)
        _mapViewContainer = MapViewContainer(map: mapView, delegate: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        centerMap(latitude: nil, longitude: nil)
    }

    @IBAction func geolocateUser() {
        centerMap(latitude: nil, longitude: nil)
    }

    private func centerMap(latitude: Double?, longitude: Double?) {
        if latitude == nil || longitude == nil {
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    _locationManager.requestWhenInUseAuthorization()
                case .restricted, .denied:
                    let alert = UIAlertController(title: "Attention", message: "Merci d'accéder à vos réglages afin d'autoriser le partage de la localisation.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                case .authorizedAlways, .authorizedWhenInUse:
                    _locationManager.startUpdatingLocation()
                }
            } else {
                let alert = UIAlertController(title: "Attention", message: "Votre géolocalisation est indisponible, merci de l'activer depuis vos réglages", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            _mapViewContainer.centerMap(latitude: latitude!, longitude: longitude!)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        centerMap(latitude: locValue.latitude, longitude: locValue.longitude)
        _locationManager.stopUpdatingLocation()
    }

    @objc private func searchForSuggestion() {
        dataManager.placeManager.searchPlaces(place: searchTextField.text!) { (places) in
            self._placeList = places
            self.suggestionTableView.reloadData()
        }

    }

    @IBAction private func hideSuggestionList() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.heightTableViewHideConstraint.priority = .defaultHigh
            self.heightTableViewShownConstraint.priority = .defaultLow
            self.leftSearchWithBackConstraint.priority = UILayoutPriority(100.0)
            self.leftSearchWithoutBackConstraint.priority = UILayoutPriority(800.0)
            self.suggestionView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

    func showSuggestionList() {
        UIView.animate(withDuration: 0.3) {
            self.heightTableViewHideConstraint.priority = .defaultLow
            self.heightTableViewShownConstraint.priority = .defaultHigh
            self.leftSearchWithBackConstraint.priority = UILayoutPriority(800.0)
            self.leftSearchWithoutBackConstraint.priority = UILayoutPriority(100.0)
            self.suggestionView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
}
//
//extension MapViewController : MGLMapViewDelegate {
//    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
//        dataManager.placeManager.geocodePlace(latitude: mapView.latitude, longitude: mapView.longitude) { (place) in
//            guard let _ = place else {
//                return
//            }
//            self.searchTextField.text = place!.printableAddress
//        }
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        view.endEditing(true)
//    }
//
//
//}

extension MapViewController : MapProtocol {

    func regionDidChange(placeName: String) {
        searchTextField.text = placeName
    }

    func didEndScroll() {
        view.endEditing(true)
    }
}

extension MapViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _placeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = suggestionTableView.dequeueReusableCell(withIdentifier: "placeCell")! as! PlaceTableViewCell
        let place = _placeList[indexPath.row]
        cell.placeLabel.text = place.printableAddress
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = _placeList[indexPath.row]
        view.endEditing(true)
        searchTextField.text = place.printableAddress
        self.hideSuggestionList()
        self.centerMap(latitude: place.latitude, longitude: place.longitude)
    }
}

extension MapViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showSuggestionList()
        _placeList = dataManager.placeManager.getSavedPlaces()
        suggestionTableView.reloadData()
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
}

