//
//  UserTablePatch.swift
//  DTO to deal with differences in naming conventions between JSON and Swift
//
//  Created by Raul Camargo on 4/1/23.
//

import Vapor
import Fluent
import FluentPostGIS

struct UserTablePatch: Content
{
    var user_name: String
    var longitude: Double
    var latitude: Double
    var userID: String
}

