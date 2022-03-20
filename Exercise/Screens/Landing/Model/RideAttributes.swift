//
//  RideAttributes.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import Foundation

struct RideAttributes : Decodable {
    
    enum VehicleType: String, Decodable {
        case escooter = "escooter"
        case any = "any"
    }
    
	let lat : Double?
	let lng : Double?
	let code : Int?
	let state : String?
	let zoneId : String?
	let maxSpeed : Int?
	let iotVendor : String?
	let isRentable : Bool?
	let vehicleType : VehicleType?
	let batteryLevel : Int?
	let licencePlate : String?
	let lastStateChange : String?
	let currentRangeMeters : Int?
	let lastLocationUpdate : String?

    enum CodingKeys: String, CodingKey {

        case lat = "lat"
        case lng = "lng"
        case code = "code"
        case state = "state"
        case zoneId = "zoneId"
        case maxSpeed = "maxSpeed"
        case iotVendor = "iotVendor"
        case isRentable = "isRentable"
        case vehicleType = "vehicleType"
        case batteryLevel = "batteryLevel"
        case licencePlate = "licencePlate"
        case lastStateChange = "lastStateChange"
        case currentRangeMeters = "currentRangeMeters"
        case lastLocationUpdate = "lastLocationUpdate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        zoneId = try values.decodeIfPresent(String.self, forKey: .zoneId)
        maxSpeed = try values.decodeIfPresent(Int.self, forKey: .maxSpeed)
        iotVendor = try values.decodeIfPresent(String.self, forKey: .iotVendor)
        isRentable = try values.decodeIfPresent(Bool.self, forKey: .isRentable)
        batteryLevel = try values.decodeIfPresent(Int.self, forKey: .batteryLevel)
        licencePlate = try values.decodeIfPresent(String.self, forKey: .licencePlate)
        lastStateChange = try values.decodeIfPresent(String.self, forKey: .lastStateChange)
        currentRangeMeters = try values.decodeIfPresent(Int.self, forKey: .currentRangeMeters)
        lastLocationUpdate = try values.decodeIfPresent(String.self, forKey: .lastLocationUpdate)
        
        vehicleType = VehicleType(rawValue: try values.decodeIfPresent(String.self, forKey: .vehicleType) ?? VehicleType.any.rawValue)
    }
}
