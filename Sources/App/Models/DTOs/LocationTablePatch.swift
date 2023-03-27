//
//  LocationTablePatch.swift
//
//  DTO for both Location and PinLocation
//
//  Created by Raul Camargo on 3/25/23.
//

import Vapor
import Fluent

struct LocationTablePatch: Decodable
{
    var location_id: String?
    var latitude: Double
    var longitude : Double
    var building_number: String?
    var street: String?
    var description: String?
}
