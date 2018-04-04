//
//  PlaceManager.swift
//  LocateMe
//
//  Created by David Fafinski on 03/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import Foundation

protocol PlaceSAL {
    func geocodePlace(latitude: Double, longitude: Double, completion:@escaping (Place?) -> Void)
    func searchPlace(place: String, completion:@escaping ([Place]) -> Void)
}

protocol PlaceDAL {
    func savePlace(place: Place)
    func getSavedPlaces() -> [Place]
}

class PlaceManager  {

    private let _placeSAL: PlaceSAL
    private let _placeDAL: PlaceDAL

    init(placeSAL : PlaceSAL, placeDAL : PlaceDAL){
        _placeSAL = placeSAL
        _placeDAL = placeDAL
    }

    func geocodePlace(latitude: Double, longitude: Double, completion:@escaping (Place?) -> Void) {
        _placeSAL.geocodePlace(latitude: latitude, longitude: longitude) { (place) in
            guard let _ = place else {
                completion(nil)
                return
            }
            self.savePlace(place: place!)
            completion(place)
        }
    }

    func searchPlaces(place: String, completion:@escaping ([Place]) -> Void) {
        _placeSAL.searchPlace(place: place) { (places) in
            completion(places)
        }
    }

    func savePlace(place: Place) {
        _placeDAL.savePlace(place: place)
    }

    func getSavedPlaces() -> [Place] {
        return _placeDAL.getSavedPlaces()
    }
}
