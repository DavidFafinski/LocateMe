//
//  MapboxContainer.swift
//  LocateMe
//
//  Created by David Fafinski on 04/04/2018.
//  Copyright © 2018 David Fafinski. All rights reserved.
//

import UIKit
import Mapbox

class MapboxContainer : NSObject, MGLMapViewDelegate {

    let kURLStringMapBox = "mapbox://styles/mapbox/streets-v10"
    var mapboxView: MGLMapView!
    private var _delegate: MapViewContainer!

    required init(view: UIView, delegate: MapViewContainer) {
        super.init()
        mapboxView = MGLMapView(frame: view.bounds, styleURL:URL(string: kURLStringMapBox))
        mapboxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapboxView.delegate = self
        _delegate = delegate
    }

    func centerMap(latitude: Double, longitude: Double) {
        mapboxView.setCenter(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), zoomLevel: 9, animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _delegate.didEndScroll()
    }

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "pin")
        if(annotationImage == nil) {
            annotationImage = MGLAnnotationImage(image: #imageLiteral(resourceName: "pin"), reuseIdentifier: "pin")
        }
        return annotationImage
    }

    func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        dataManager.placeManager.geocodePlace(latitude: mapView.latitude, longitude: mapView.longitude) { (place) in
            guard let _ = place else {
                return
            }
            self._delegate.regionDidChange(placeName: place!.printableAddress)
        }
    }

}
