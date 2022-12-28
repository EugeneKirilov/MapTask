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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegates()
        setConstraints()
        mapCentering()
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
    
    @objc func resetButtonTapped() {
        print("resetButtonTapped")
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

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
  
}

