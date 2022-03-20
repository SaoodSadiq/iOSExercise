//
//  RideDataManager.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import Foundation
import SwiftUI

protocol RideDataManagerProtocol {
    func fetchAllRides(_ completion: @escaping (Result)->())
}

class RideDataManager {
    
    static let shared: RideDataManagerProtocol = RideDataManager(networkManager: JsonbinApiManager())
    
    private init(networkManager: JsonbinApiClientProtocol) {
        self.networkManager = networkManager
    }
    
    private let networkManager: JsonbinApiClientProtocol
    
}

extension RideDataManager: RideDataManagerProtocol {
    
    func fetchAllRides(_ completion: @escaping (Result)->())  {
        networkManager.getAllRides(type: [Ride].self, completion: { result in
            DispatchQueue.main.async {
                /// to handle optional cases e.g: save in database or expire cache,
                switch result {
                case .success(_ ):
                    print("success")
                case .failure(let error):
                    print(error)
                }
            }
            completion(result)
        })
    }
}
