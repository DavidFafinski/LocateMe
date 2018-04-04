//
//  PlaceMapboxServices.swift
//  LocateMe
//
//  Created by David Fafinski on 04/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import Foundation
import MapboxGeocoder

class PlaceMapboxServices : PlaceSAL {

    private let geocoder = Geocoder.shared

    func geocodePlace(latitude: Double, longitude: Double, completion:@escaping (Place?) -> Void) {
        let options = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                completion(nil)
                return
            }
            completion(Place(placesDictionary: placemark.addressDictionary as! [String: Any], latitude: latitude, longitude: longitude))
        }
    }

    func searchPlace(place: String, completion: @escaping ([Place]) -> Void) {
        let options = ForwardGeocodeOptions(query: place)
        options.allowedScopes = [.address, .pointOfInterest]
        geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemarks = placemarks, placemarks.count > 0 else {
                completion([])
                return
            }
            let result = placemarks.filter({$0.location != nil && $0.qualifiedName != nil && !($0.qualifiedName?.isEmpty)!})
            completion(result.map {Place(placesDictionary: $0.addressDictionary as! [String: Any], latitude: $0.location!.coordinate.latitude, longitude: $0.location!.coordinate.longitude)})
        }
    }
}
