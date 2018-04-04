//
//  Place.swift
//  LocateMe
//
//  Created by David Fafinski on 03/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import Foundation
import CoreLocation

class Place {

    var streetNumber: String?
    var streetName: String?
    var city: String?
    var postalCode: String?
    var latitude: Double?
    var longitude: Double?
    var printableAddress: String! {
        get {
             return printableStreet + ", " + printableCity
        }
    }
    var printableStreet: String {
        get {
            var res = ""
            if let streetNum = self.streetNumber {
                res = streetNum + " "
            }
            if let streetName = self.streetName {
                res += streetName
            }
            return res
        }
    }
    var printableCity: String {
        get {
            if let postal = self.postalCode, let city = self.city {
                return postal + " " + city
            } else if let postal = self.postalCode {
                return postal
            } else if let city = self.city {
                return city
            } else {
                return ""
            }
        }
    }
    init(placesDictionary: [String: Any], latitude: Double, longitude: Double) {
        self.streetNumber = placesDictionary["subThoroughfare"] as? String
        self.streetName = placesDictionary["street"] as? String
        self.postalCode = placesDictionary["postalCode"] as? String
        self.city = placesDictionary["subAdministrativeArea"] as? String
        self.latitude = latitude
        self.longitude = longitude
    }

}
