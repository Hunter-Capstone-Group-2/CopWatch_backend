//
//  PinTablePatch.swift
//  DTO to deal with differences in naming conventions between JSON and Swift
//  and between PostGIS and Swift
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
    // Added 20230503 migration
    var report: String
    var report_detail: String
    var report_location: String
}

// Patch for encoding the return data in a Swift friendly way
struct PinReturn: Content
{
    var id: UUID
    var userID: String
    var confirmed: Bool
    var longitude: Double
    var latitude: Double
    var time_created: Date
    var time_confirmed: Date
    // Added 20230503 migration
    var report: String
    var report_detail: String
    var report_location: String 
}
