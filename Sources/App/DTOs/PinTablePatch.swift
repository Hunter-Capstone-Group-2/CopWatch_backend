//
//  PinTablePatch.swift
//  
//
//  Created by Raul Camargo on 4/10/23.
//

import Vapor
import Fluent
import FluentPostGIS

struct PinTablePatch: Content
{
    var userID: String
    var confirmed: Bool
    var longitude: Double
    var latitude: Double
}
