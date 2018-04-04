//
//  MapViewContainer.swift
//  LocateMe
//
//  Created by David Fafinski on 04/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

protocol MapProtocol {
    func regionDidChange(placeName: String)
    func didEndScroll()
}

class MapViewContainer {

    private var _view: UIView!
    private var _delegate: MapViewController!
    private var _mapboxContainer: MapboxContainer!

    init(map: UIView, delegate: MapViewController) {
        _mapboxContainer = MapboxContainer(view: MGLMapView(frame: map.bounds), delegate: self)
        _view = map
        _view.addSubview(_mapboxContainer.mapboxView)
        _delegate = delegate
    }

    func centerMap(latitude: Double, longitude: Double) {
        _mapboxContainer.centerMap(latitude: latitude, longitude: longitude)
    }

    func regionDidChange(placeName: String) {
        _delegate.regionDidChange(placeName: placeName)
    }

    func didEndScroll() {
        _delegate.didEndScroll()
    }
    
}
