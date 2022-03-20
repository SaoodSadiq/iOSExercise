//
//  LandingViewController.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import UIKit
import MapKit
import Combine

fileprivate let kLocationPopupHeight = 140.0

class LandingViewController: UIViewController {

    private var viewModel = LandingViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    @IBOutlet private weak var mapView: MapView!
    private var userTrackingButton: MKUserTrackingButton!
    @IBOutlet weak var locationPopupHeightConstraint: NSLayoutConstraint!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rides Near You"
        
        initializeMapProps()
        
        self.bindViewModel()
        viewModel.fetchAllRides()
    }
    
    private func bindViewModel() {
        viewModel.$rides
            .sink { [weak self] in self?.mapView.addAnnotationsToMap(rides: $0)}
            .store(in: &cancellables)
        
        viewModel.$error
            .sink { [weak self] in
                if let err = $0 {
                    self?.showApiError(error: err)
                    print(err)
                }
            }
            .store(in: &cancellables)
    }
    
    @IBAction func onAllowLocationButtonPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
}

// MARK: Map View
extension LandingViewController {
    
    private func initializeMapProps() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.initializeMapProps()
        mapView.setRegion(location: locationManager.location)
        mapView.mapViewDelegate = self
        setupMapButtons()
        showHideAllowLocationView()
    }
    
    private func setupMapButtons() {
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: userTrackingButton)
    }
    
    private func showHideAllowLocationView(hide:Bool = true) {
        if CLLocationManager.locationServicesEnabled() || hide {
            locationPopupHeightConstraint.constant = 0
            userTrackingButton?.isHidden = false
        }
        else {
            locationPopupHeightConstraint.constant = kLocationPopupHeight
            userTrackingButton?.isHidden = true
        }
    }
}

// MARK: Map View Delegate
extension LandingViewController: MapViewDelegate {
    
    func mapView(_ mapView: MapView, didFailToLocateUserWithError error: Error) {
        showHideAllowLocationView(hide: false)
    }
    
    func mapView(_ mapView: MapView, annotationDidSelected view: MKAnnotationView) {
        callOutView(annotationView: view, userLocation: mapView.userLocation.location)
    }
    
    func callOutView(annotationView:MKAnnotationView, userLocation: CLLocation?) {
        guard let rideAnnotation = annotationView.annotation as? Ride else { return }

        if let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "CalloutView") as? CalloutView {
            popoverContent.updatePopOverViewController(annotationView, with: self)
            present(popoverContent, animated: true, completion: nil)
            popoverContent.setUIDetails(userLocation: userLocation, ride: rideAnnotation)
        }
    }
}

// MARK: Location Delegate
extension LandingViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .authorizedAlways, .authorizedWhenInUse:
                mapView.setRegion(location: locationManager.location)
                print("Authorize.")
                break
                
            case .notDetermined, .restricted, .denied:
                print("Not determined.")
                break
                
            default:
                break
            }
        }
        showHideAllowLocationView()
    }
}

// MARK: Popup Delegate
extension LandingViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: Error Alert
extension LandingViewController {
    func showApiError(error: EXError) {
        let alertController = UIAlertController(title: "API Error!", message:
                                                    error.desc, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
        }))
        
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] action in
            self?.viewModel.fetchAllRides()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
