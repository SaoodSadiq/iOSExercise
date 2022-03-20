//
//  MapView.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import MapKit

protocol MapViewDelegate: AnyObject {
    func mapView(_ mapView: MapView, annotationDidSelected view: MKAnnotationView)
    func mapView(_ mapView: MapView, didFailToLocateUserWithError error: Error)
}

class MapView: MKMapView {
    
    weak var mapViewDelegate:MapViewDelegate?
    
    func addAnnotationsToMap(rides: [Ride]) {
        self.addAnnotations(rides)
    }

    private func registerAnnotationViewClasses() {
        register(ScooterAnnotationView.self, forAnnotationViewWithReuseIdentifier: ScooterAnnotationView.ReuseID)
        register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func initializeMapProps() {
        self.delegate = self
        self.showsUserLocation = true
        registerAnnotationViewClasses()
        accessibilityIdentifier = "mapView"
        //self.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 800, maxCenterCoordinateDistance: 100000)
    }
    
    func setRegion(location:CLLocation?) {
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        if let loc = location {
            let region = MKCoordinateRegion(center: loc.coordinate, span: span)
            setRegion(region, animated: true)
        }
    }
    
}

extension MapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let rideAnnotation = annotation as? Ride, let attributes = rideAnnotation.attributes else { return nil }
        
        switch attributes.vehicleType {
        case .escooter:
            return ScooterAnnotationView(annotation: annotation, reuseIdentifier: ScooterAnnotationView.ReuseID)
        default:
            //return nil
            /// if vehicle type not identified
            return ScooterAnnotationView(annotation: annotation, reuseIdentifier: ScooterAnnotationView.ReuseID)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        switch view {
        case is ClusterAnnotationView:
            let currentSpan = mapView.region.span
            let zoomSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 4.0, longitudeDelta: currentSpan.longitudeDelta / 4.0)
            let zoomCoordinate = view.annotation?.coordinate ?? mapView.region.center
            let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
            mapView.setRegion(zoomed, animated: true)

        case is ScooterAnnotationView:
            self.mapViewDelegate?.mapView(self, annotationDidSelected: view)
        
        default:
            return
        }
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        self.mapViewDelegate?.mapView(self, didFailToLocateUserWithError: error)
    }
}
