//
//  Ride.swift
//  Exercise
//
//  Created by MUhammad Sadiq on 19/03/2022.
//

import MapKit

class Ride : NSObject, Decodable, MKAnnotation {
    
	let id : String?
	let type : String?
	let attributes : RideAttributes?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case type = "type"
		case attributes = "attributes"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		attributes = try values.decodeIfPresent(RideAttributes.self, forKey: .attributes)
	}

    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: attributes?.lat ?? 0, longitude: attributes?.lng ?? 0)
        }
    }
}
