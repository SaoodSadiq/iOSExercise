//
//  JsonbinApiManager.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import Foundation

struct JsonbinApiManager: JsonbinApiClientProtocol {

    private let client = JsonbinApiClient()
    
    func getAllRides<T>(type: T.Type, completion: @escaping (Result) -> Void) where T : Decodable {
        client.getAllRides(type: type, completion: completion)
    }
}

class TestABC {
    func callApi() {
        JsonbinApiManager().getAllRides(type:ABC.self) { result in
            switch result {
            case .success(let t):
                print(t)
            case .failure(let fXError):
                print(fXError.desc)
            }
        }
    }
}

class ABC:Decodable {
    
}
