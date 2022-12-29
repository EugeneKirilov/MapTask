//
//  ViewController.swift
//  MapTask
//
//  Created by Zenya Kirilov on 28.12.22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    private let mapView: MKMapView = {
       let mapView = MKMapView()
        mapView.isRotateEnabled = false
        mapView.mapType = .hybrid
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let squareLabel: UILabel = {
       let label = UILabel()
        label.text = "0.00 m2"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.backgroundColor = #colorLiteral(red: 0.5302652121, green: 0.5568788052, blue: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Reset"), for: .normal)
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
        setConstraints()
        mapCentering()
        addGestureRecognizers()
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
        let minsk = CLLocation(latitude: 53.901635, longitude: 27.548736)
        let regionRadius: CLLocationDistance = 692000.0
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
    
    @objc func resetButtonTapped() {
        if !annotationsArray.isEmpty && !points.isEmpty {
            annotationsArray.removeLast()
            points.removeLast()
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(annotationsArray)
            
            let polygon = MKPolygon(coordinates: &points, count: points.count)
            mapView.removeOverlays(mapView.overlays)
            mapView.addOverlay(polygon)
            
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
        
        mapView.addAnnotations(annotationsArray)
        mapView.addOverlay(polygon)
    }
}

// MARK: - SetConstraints
extension ViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            resetButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            resetButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            resetButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            squareLabel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            squareLabel.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            squareLabel.trailingAnchor.constraint(equalTo: resetButton.leadingAnchor, constant: -20),
            squareLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is MKMarkerAnnotationView)
    }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.fillColor = #colorLiteral(red: 0.5302652121, green: 0.5568788052, blue: 1, alpha: 1)
            polygonRenderer.strokeColor = #colorLiteral(red: 0.5302652121, green: 0.5568788052, blue: 1, alpha: 1)
            polygonRenderer.alpha = 0.7
            polygonRenderer.lineWidth = 2
            return polygonRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

// MARK: - Polygon square calculation
private extension ViewController {
    func radians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }

    func regionArea(locations: [CLLocationCoordinate2D]) -> Double {
        let kEarthRadius = 6378137.0
        
        guard locations.count > 2 else { return 0 }
        
        var area = 0.0

        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]

            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
        }
        
        area = -(area * kEarthRadius * kEarthRadius / 2)
        return max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
    }
}

