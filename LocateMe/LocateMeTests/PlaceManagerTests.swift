
//
//  PlaceManagerTests.swift
//  LocateMeTests
//
//  Created by David Fafinski on 05/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import XCTest

class PlaceManagerTests: XCTestCase {
    let placeManager        = PlaceManager(placeSAL: PlaceMapboxServices(), placeDAL: PlaceUserDefaultStorage())
    let streetNameTest      = "Allée de la haye du temple"
    let streetNumberTest    = "2"
    let cityTest            = "Lomme"
    let postalCodeTest      = "59320"
    let latitudeTest        = 10.0
    let longitudeTest       = 10.0
    let printableTest       = "2 Allée de la haye du temple, 59320 Lomme"

    func testGeocodePlace() {
        placeManager.geocodePlace(latitude: 10, longitude: 10) { (place) in
            XCTAssertNil(place)
        }
    }

    func testSearchPlace() {
        placeManager.searchPlaces(place: "Lille") { (places) in
            XCTAssertNil(places)
        }
    }

}

