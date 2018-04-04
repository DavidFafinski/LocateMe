//
//  DataManager.swift
//  LocateMe
//
//  Created by David Fafinski on 03/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import Foundation

class DataManager {

    let placeManager: PlaceManager

    init() {
        placeManager = PlaceManager(placeSAL: PlaceMapboxServices(), placeDAL: PlaceUserDefaultStorage())
    }

}
