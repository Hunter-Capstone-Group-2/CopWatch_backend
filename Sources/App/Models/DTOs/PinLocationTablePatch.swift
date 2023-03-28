//
//  File.swift
//  
//
//  Created by Raul Camargo on 3/27/23.
//

import Vapor
import Fluent

struct PinLocationTablePatch: Decodable
{
    var location_id: String?
    var latitude: Double
    var longitude : Double
    var building_number: String?
    var street: String?
    var description: String?
}

