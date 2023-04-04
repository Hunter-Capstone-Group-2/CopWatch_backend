//
//  UserTablePatch.swift
//  
//
//  Created by Raul Camargo on 4/1/23.
//

import Vapor
import Fluent
import FluentPostGIS

struct UserTablePatch: Decodable
{
    var user_id: String?
    var user_name: String
    var user_location: GeographicPoint2D
}

