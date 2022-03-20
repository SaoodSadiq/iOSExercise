//
//  JsonbinApiClient.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import Foundation

fileprivate enum JsonbinApi {
    
    case rides
    
    var baseUrl: String {
        return "https://api.npoint.io"
    }
    
    var url:String {
        switch self {
        case .rides:
            return "\(baseUrl)/9d8dd290a650ba9d55c1"
        }
    }
}

protocol JsonbinApiClientProtocol {
    func getAllRides<T:Decodable>(type:T.Type, completion : @escaping (Result) -> Void)
}

struct JsonbinApiClient: BaseNetworkApi, JsonbinApiClientProtocol {
    
    func getAllRides<T:Decodable>(type:T.Type, completion : @escaping (Result) -> Void) {
    
        let url = JsonbinApi.rides.url
        self.networkRequest(with: url, objectType: type) { (result: Result) in
            completion(result)
        }
    }
}
