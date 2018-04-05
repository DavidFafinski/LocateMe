//
//  PlaceUserDefaultStorage.swift
//  LocateMe
//
//  Created by David Fafinski on 04/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import Foundation

class PlaceUserDefaultStorage : PlaceDAL {

    let storageKey = "placesHistory"
    let historyPlacesLength = 2

    func savePlace(place: Place) {
        var places = getSavedPlaces()
        if (places.count >= historyPlacesLength) {
                places.removeLast() 
        }
        places.insert(place, at: 0)
        let userDefaults = UserDefaults.standard
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: places), forKey: storageKey)
    }

    func getSavedPlaces() -> [Place] {
        let userDefaults = UserDefaults.standard
        if let places = userDefaults.value(forKey: storageKey) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: places) as! [Place]
        } else {
            return []
        }
    }

}
