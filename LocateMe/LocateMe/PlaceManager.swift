//
//  PlaceManager.swift
//  LocateMe
//
//  Created by David Fafinski on 03/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import Foundation
import MapboxGeocoder

class PlaceManager {

    private let geocoder = Geocoder.shared

    func searchPlaces(place: String, completion:@escaping ([Place]) -> Void) {
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
