//
//  UuusMapKit.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import MapKit

open class MapContro1ler: UuusController {
    public var mapView = MKMapView()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        let address = stevenash as? String ?? String.short
        navigationItem.title = address.local
        CLGeocoder().geocodeAddressString(address) { [weak self] (placemarks, error) in
            guard error == nil else {
                return
            }
            guard let placemark = placemarks?.first else {
                return
            }
            let coordinate = placemark.location?.coordinate ?? CLLocationCoordinate2D()
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 2046, 2046)
            self?.mapView.setRegion(region, animated: true)
            self?.mapView.isZoomEnabled = true
            self?.mapView.addAnnotation(MKPlacemark(placemark: placemark))
        }
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard mapView.superview == nil else {
            return
        }
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}
