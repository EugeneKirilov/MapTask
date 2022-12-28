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
//        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var annotationsArray = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegates()
        setConstraints()
        mapCentering()
        addGestureRecognizers()
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
        print("resetButtonTapped")
    }
    
    @objc func foundTap(_ recognizer: UITapGestureRecognizer) {
        print("foundTap")
        let point = recognizer.location(in: mapView)
        let tapPoint = mapView.convert(point, toCoordinateFrom: view)
        let placemark = MKPointAnnotation()
        placemark.coordinate = tapPoint
        mapView.addAnnotation(placemark)
//        mapView.addOverlay(placemark as? MKOverlay)
        annotationsArray.append(placemark)
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
        if overlay.isKind(of: MKPolygon.self) {
            var poligonRenderer = MKPolygonRenderer(overlay: overlay)
            poligonRenderer.fillColor = #colorLiteral(red: 0.5302652121, green: 0.5568788052, blue: 1, alpha: 1)
            poligonRenderer.strokeColor = #colorLiteral(red: 0.5302652121, green: 0.5568788052, blue: 1, alpha: 0.5990790563)
            poligonRenderer.lineWidth = 2
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

