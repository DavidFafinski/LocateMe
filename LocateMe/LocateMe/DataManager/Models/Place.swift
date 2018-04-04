//
//  Place.swift
//  LocateMe
//
//  Created by David Fafinski on 03/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import Foundation
import CoreLocation

class Place : NSObject, NSCoding {

    let kStreetName     = "street"
    let kStreetNumber   = "subThoroughfare"
    let kCity           = "subAdministrativeArea"
    let kPostalCode     = "postalCode"
    let kLatitude       = "latitude"
    let kLongitude      = "longitude"

    var streetNumber: String?
    var streetName: String?
    var city: String?
    var postalCode: String?
    var latitude: Double?
    var longitude: Double?
    var printableAddress: String! {
        get {
            if printableStreet != "" {
                return printableStreet + ", " + printableCity
            } else {
                return printableCity
            }
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
        self.streetNumber = placesDictionary[kStreetNumber] as? String
        self.streetName = placesDictionary[kStreetName] as? String
        self.postalCode = placesDictionary[kPostalCode] as? String
        self.city = placesDictionary[kCity] as? String
        self.latitude = latitude
        self.longitude = longitude
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.streetName, forKey: kStreetName)
        aCoder.encode(self.streetNumber, forKey: kStreetNumber)
        aCoder.encode(self.postalCode, forKey: kPostalCode)
        aCoder.encode(self.city, forKey: kCity)
        aCoder.encode(self.latitude, forKey: kLatitude)
        aCoder.encode(self.longitude, forKey: kLongitude)
    }

    required init?(coder aDecoder: NSCoder) {
        self.streetName = aDecoder.decodeObject(forKey: kStreetName) as? String
        self.streetNumber = aDecoder.decodeObject(forKey: kStreetNumber) as? String
        self.postalCode = aDecoder.decodeObject(forKey: kPostalCode) as? String
        self.city = aDecoder.decodeObject(forKey: kCity) as? String
        self.latitude = aDecoder.decodeObject(forKey: kLatitude) as? Double
        self.longitude = aDecoder.decodeObject(forKey: kLongitude) as? Double
    }


}
