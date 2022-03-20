//
//  LandingViewModel.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import UIKit
import Combine

protocol LandingViewModelProtocol {
    var rides: [Ride] { get set }
    func fetchAllRides()
}

class LandingViewModel:ObservableObject, LandingViewModelProtocol {
    @Published var rides = [Ride]()
    @Published var error: EXError?
    
    private var dataManager: RideDataManagerProtocol
        
    init(dataManager: RideDataManagerProtocol = RideDataManager.shared) {
        self.dataManager = dataManager
    }
}

extension LandingViewModel {
    func fetchAllRides() {
        self.dataManager.fetchAllRides { [weak self] result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let decodable):
                    self?.rides = decodable as? [Ride] ?? []
                case .failure(let eXError):
                    self?.error = eXError
                }
            }
        }
    }
}
