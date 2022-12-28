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
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.layer.cornerRadius = 20
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupDelegates()
        setConstraints()
    }

    private func setupViews() {
        view.addSubview(mapView)
        view.addSubview(resetButton)
        view.addSubview(squareLabel)
    }
    
    private func setupDelegates() {
        
    }
    
    @objc func resetButtonTapped() {
        print("resetButtonTapped")
    }

}

//MARK: - SetConstraints
extension ViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            squareLabel.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            squareLabel.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            squareLabel.widthAnchor.constraint(equalToConstant: 100),
            squareLabel.heightAnchor.constraint(equalToConstant: 50),
            
            resetButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            resetButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            resetButton.widthAnchor.constraint(equalToConstant: 100),
            resetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

