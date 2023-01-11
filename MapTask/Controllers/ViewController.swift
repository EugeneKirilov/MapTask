//
//  ViewController.swift
//  MapTask
//
//  Created by Zenya Kirilov on 28.12.22.
//

import UIKit
import MapKit
import CoreLocation

final class ViewController: UIViewController {
    
    private let mapView: MKMapView = {
       let mapView = MKMapView()
        mapView.isRotateEnabled = false
        mapView.mapType = .hybrid
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let squareLabel: UILabel = {
       let label = UILabel()
        label.text = StringConstants.startSquareLabelText.rawValue
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CGFloatConstants.twentyPoints.rawValue)
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = CGFloatConstants.twentyPoints.rawValue
        label.clipsToBounds = true
        label.backgroundColor = UIColor(named: StringConstants.veriPeriColor.rawValue)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: StringConstants.resetButton.rawValue), for: .normal)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var annotationsArray = [MKPointAnnotation]()
    private var points = [CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegates()
        mapCentering()
        addGestureRecognizers()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAlert()
    }

    private func setupViews() {
        view.addSubview(mapView)
        view.addSubview(resetButton)
        view.addSubview(squareLabel)
    }
    
    private func setupDelegates() {
        mapView.delegate = self
    }
    
    private func mapCentering() {
        let minsk = CLLocation(latitude: DoubleConstants.minskLatitude.rawValue,
                               longitude: DoubleConstants.minskLongitude.rawValue)
        let regionRadius: CLLocationDistance = DoubleConstants.regionRadius.rawValue
        let region = MKCoordinateRegion(center: minsk.coordinate,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        
        mapView.setRegion(region, animated: true)
    }
    
    private func addGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(foundTap(_:)))
        tapGestureRecognizer.delegate = self
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            resetButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: CGFloatConstants.minusTwentyPoints.rawValue),
            resetButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: CGFloatConstants.minusThirtyPoints.rawValue),
            resetButton.widthAnchor.constraint(equalToConstant: CGFloatConstants.hundredPoints.rawValue),
            resetButton.heightAnchor.constraint(equalToConstant: CGFloatConstants.fiftyPoints.rawValue),
            
            squareLabel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: CGFloatConstants.twentyPoints.rawValue),
            squareLabel.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: CGFloatConstants.minusThirtyPoints.rawValue),
            squareLabel.trailingAnchor.constraint(equalTo: resetButton.leadingAnchor, constant: CGFloatConstants.minusTwentyPoints.rawValue),
            squareLabel.heightAnchor.constraint(equalToConstant: CGFloatConstants.fiftyPoints.rawValue)
        ])
    }
    
    @objc func resetButtonTapped() {
        if !annotationsArray.isEmpty && !points.isEmpty {
            annotationsArray.removeLast()
            points.removeLast()
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(annotationsArray)
            
            let polygon = MKPolygon(coordinates: &points, count: points.count)
            mapView.removeOverlays(mapView.overlays)
            mapView.addOverlay(polygon)
            
            squareLabel.text = "\(regionArea(locations: points)) \(StringConstants.squareMeters.rawValue)"
            
            if annotationsArray.count == 0 {
                resetButton.isHidden = true
            }
        }
    }
    
    @objc func foundTap(_ recognizer: UITapGestureRecognizer) {
        mapView.removeOverlays(mapView.overlays)
        let point = recognizer.location(in: mapView)
        let tapPoint = mapView.convert(point, toCoordinateFrom: view)
        let placemark = MKPointAnnotation()
        placemark.coordinate = tapPoint
        annotationsArray.append(placemark)
        points.append(tapPoint)
        
        let polygon = MKPolygon(coordinates: &points, count: points.count)
        
        if annotationsArray.count > 0 {
            resetButton.isHidden = false
        }
        
        squareLabel.text = "\(regionArea(locations: points)) \(StringConstants.squareMeters.rawValue)"
        
        mapView.addAnnotations(annotationsArray)
        mapView.addOverlay(polygon)
    }
}



