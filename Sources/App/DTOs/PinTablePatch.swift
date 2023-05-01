//
//  PinTablePatch.swift
//  
//
//  Created by Raul Camargo on 4/10/23.
//

import Vapor
import Fluent

struct PinTablePatch: Content
{
    var userID: String
    var confirmed: Bool
    var longitude: Double
    var latitude: Double
}

struct PinReturn: Content
{
    var id: UUID
    var userID: String
    var confirmed: Bool
    var longitude: Double
    var latitude: Double
    var time_created: Date
    var time_confirmed: Date
}
