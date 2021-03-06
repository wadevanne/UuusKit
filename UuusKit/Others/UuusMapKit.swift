//
//  UuusMapKit.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import MapKit

@IBDesignable
open class MapViewControllor: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var safeToolbar: UIToolbar!

    // MARK: - IBInspectable

    @IBInspectable public var address: String? {
        didSet {
            let coordinate = "\(latitude), \(longitude)"
            navigationItem.title = address ?? coordinate
            guard 2 > address?.count ?? 0 else {
                geocodeAddressString(address!)
                return
            }
            address(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
    }

    /// CLLocationDegrees
    @IBInspectable public var latitude: Double = 22.320048
    /// CLLocationDegrees
    @IBInspectable public var longitude: Double = 114.173355

    // MARK: - Properties

    public var mapView = MKMapView()

    // MARK: - View Handling

    open override func viewDidLoad() {
        super.viewDidLoad()
        safeToolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        safeToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        address = (stevenash as? String)?.local
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard mapView.superview == nil else {
            return
        }
        view.insertSubview(mapView, at: 0)
        mapView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaInsets)
            } else {
                make.edges.equalTo(view)
            }
        }
    }

    // MARK: - Public - Functions

    open func geocodeAddressString(_ address: String) {
        CLGeocoder().geocodeAddressString(address) { [weak self] placemarks, error in
            guard error == nil else {
                return
            }
            guard let placemark = placemarks?.first else { return }
            self?.setRegion(placemark.location?.coordinate)
            self?.addAnnotation(MKPlacemark(placemark: placemark))
        }
    }

    open func address(_ centerCoordinate: CLLocationCoordinate2D!) {
        let placemark = MKPlacemark(coordinate: centerCoordinate, addressDictionary: nil)
        setRegion(placemark.coordinate)
        addAnnotation(placemark)
    }

    open func setRegion(_ centerCoordinate: CLLocationCoordinate2D?) {
        let coordinate = centerCoordinate ?? CLLocationCoordinate2D()
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2046, longitudinalMeters: 2046)
        mapView.setRegion(region, animated: true)
    }

    open func addAnnotation(_ annotation: MKAnnotation, isClear: Bool = true) {
        if isClear {
            mapView.removeAnnotations(mapView.annotations)
        }
        mapView.addAnnotation(annotation)
    }
}
