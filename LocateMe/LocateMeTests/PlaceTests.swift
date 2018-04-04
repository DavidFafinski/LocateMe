//
//  PlaceTests.swift
//  LocateMeTests
//
//  Created by David Fafinski on 04/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import XCTest

class PlaceTests: XCTestCase {

    let streetNameTest      = "Allée de la haye du temple"
    let streetNumberTest    = "2"
    let cityTest            = "Lomme"
    let postalCodeTest      = "59320"
    let latitudeTest        = 10.0
    let longitudeTest       = 10.0
    let printableTest       = "2 Allée de la haye du temple, 59320 Lomme"
    var place: Place!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        place = Place(streetName: streetNameTest, streetNumber: streetNumberTest, city: cityTest, postalCode: postalCodeTest, longitude: longitudeTest, latitude: latitudeTest)
    }

    func testInitPlace() {
        XCTAssertTrue(place.streetNumber == streetNumberTest)
        XCTAssertTrue(place.streetName == streetNameTest)
        XCTAssertTrue(place.city == cityTest)
        XCTAssertTrue(place.postalCode == postalCodeTest)
        XCTAssertTrue(place.latitude == latitudeTest)
        XCTAssertTrue(place.longitude == longitudeTest)
    }

    func testPrintableAddress() {
        XCTAssertTrue(place.printableAddress == printableTest)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

}
