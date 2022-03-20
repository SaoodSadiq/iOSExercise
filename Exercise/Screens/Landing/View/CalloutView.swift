//
//  CalloutView.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 20/03/2022.
//

import UIKit
import MapKit

class CalloutView: UIViewController {
    
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var plateNoLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "callOutView"

    }
    
    override var preferredContentSize: CGSize {
        get {
            let size = CGSize(width: 240, height: 108)
            return size
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    func updatePopOverViewController(_ sView: UIView?, with delegate: UIPopoverPresentationControllerDelegate?) {
        guard let sourceView = sView else { return }
        modalPresentationStyle = .popover
        popoverPresentationController?.permittedArrowDirections = [.any]
        popoverPresentationController?.backgroundColor = UIColor.purple
        popoverPresentationController?.sourceView = sourceView
        popoverPresentationController?.sourceRect = sourceView.bounds
        popoverPresentationController?.delegate = delegate
       
    }
    
    func setUIDetails(userLocation: CLLocation?, ride:Ride) {
        let annotationLocation = CLLocation(latitude: ride.coordinate.latitude, longitude: ride.coordinate.longitude)
        if let loc = userLocation {
            let distance = annotationLocation.distance(from: loc)
            rangeLabel?.text = "Distance : " + ((distance > 1000) ? "\(round(distance/1000)) km" : "\(round(distance)) m")
        }
        vehicleTypeLabel?.text = "Vehicle : \(String(describing: ride.attributes?.vehicleType?.rawValue ?? ""))"
        plateNoLabel?.text = "Plate No. : \(String(describing: ride.attributes?.licencePlate ?? ""))"
    }

}
