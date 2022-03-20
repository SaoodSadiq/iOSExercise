//
//  BaseNetworkApi.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import Foundation

enum EXError: Error {
    
    case quotaExhausted
    case networkError(Error?)
    case dataNotFound
    case jsonParsingError(Error?)
    
    var desc:String {
        switch self {
        case .quotaExhausted:
            return "API Requests Quota is Exhausted. Purchase more requests at https://jsonbin.io/pricing."
        case .networkError(let error):
            return error?.localizedDescription ?? ""
        case .dataNotFound:
            return "Data not Found"
        case .jsonParsingError(let error):
            return error?.localizedDescription ?? ""
        }
    }
    
    static func convertTo(error:Error?, code:Int? = nil) -> EXError {
        switch (error as NSError?)?.code ?? code ?? 0 {
        case -1:
            return .quotaExhausted
        default:
            return .networkError(error)
        }
    }
}

enum Result {
    case success(Decodable)
    case failure(EXError)
}

protocol BaseNetworkApi {
    func networkRequest<T: Decodable>(with url: String, objectType: T.Type, completion: @escaping (Result) -> Void)
}

extension BaseNetworkApi {
    func networkRequest<T: Decodable>(with url: String, objectType: T.Type, completion: @escaping (Result) -> Void) {
        
        if let dataURL = URL(string: url) {
            
            let session = URLSession.shared
            let request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                
                guard let data = data, !data.isEmpty else {
                    completion(Result.failure(EXError.dataNotFound))
                    return
                }
                guard error == nil else {
                    completion(Result.failure(EXError.convertTo(error: error)))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let isSuccess = json?["success"] as? Bool, isSuccess == false {
                        completion(Result.failure(EXError.convertTo(error: nil, code:-1)))
                    }
                    else {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: json?["data"] as Any, options: [])  {
                            let decodedObject = try JSONDecoder().decode(objectType.self, from: jsonData)
                            completion(Result.success(decodedObject))
                        }
                        else {
                            completion(Result.failure(EXError.dataNotFound))
                        }
                    }
                }
                catch let error {
                    completion(Result.failure(EXError.jsonParsingError(error as? DecodingError)))
                }
                
            })
            
            task.resume()
        }
    }
}
