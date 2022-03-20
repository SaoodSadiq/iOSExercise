//
//  ScooterAnnotationView.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import MapKit

class ScooterAnnotationView: MKAnnotationView {

    static let ReuseID = "ScooterAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "ScooterAnnotationView"
        accessibilityIdentifier = "annotation"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        tintColor = .red
        image = UIImage(named: "scooter")
        canShowCallout = false
    }
    
    
}
