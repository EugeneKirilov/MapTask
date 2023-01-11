//
//  ViewController + Extension.swift
//  MapTask
//
//  Created by Zenya Kirilov on 29.12.22.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

extension ViewController {
    enum StringConstants: String {
        case welcomeAlertTitle = "Welcome to square counter app!"
        case welcomeAlertMessage = "You can add pins on the map and square will be counted automatically."
        case welcomeActionTitle = "I understand!"
        case veriPeriColor = "veriPeri"
        case startSquareLabelText = "0.0 m2"
        case resetButton = "Reset"
        case squareMeters = "m2"
    }
    
    enum DoubleConstants: Double {
        case polygonAlpha = 0.7
        case kEarthRadius = 6378137.0
        case minskLatitude = 53.901635
        case minskLongitude = 27.548736
        case regionRadius = 692000.0
    }
    
    enum CGFloatConstants: CGFloat {
        case polygonLineWidth = 2
        case twentyPoints = 20
        case minusTwentyPoints = -20
        case minusThirtyPoints = -30
        case fiftyPoints = 50
        case hundredPoints = 100
    }
}

extension ViewController {
    func startAlert() {
        let alert = UIAlertController(title: StringConstants.welcomeAlertTitle.rawValue,
                                      message: StringConstants.welcomeAlertMessage.rawValue,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: StringConstants.welcomeActionTitle.rawValue, style: .default)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !(touch.view is MKMarkerAnnotationView)
    }
}

extension ViewController: MKMapViewDelegate {
    // не выносил в Extension MKOverlay, потому что пришлось бы дублировать константы или делать их глобальными
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.fillColor = UIColor(named: StringConstants.veriPeriColor.rawValue)
            polygonRenderer.strokeColor = UIColor(named: StringConstants.veriPeriColor.rawValue)
            polygonRenderer.alpha = DoubleConstants.polygonAlpha.rawValue
            polygonRenderer.lineWidth = CGFloatConstants.polygonLineWidth.rawValue
            return polygonRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

extension ViewController {
    func regionArea(locations: [CLLocationCoordinate2D]) -> Double {
        let kEarthRadius = DoubleConstants.kEarthRadius.rawValue
        
        guard locations.count > 2 else { return 0 }
        
        var area = 0.0

        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]

            area += (p2.longitude - p1.longitude).radians() * (2 + sin(p1.latitude.radians()) + sin(p2.latitude.radians()) )
        }
        
        area = -(area * kEarthRadius * kEarthRadius / 2)
        
        return max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
    }
}
