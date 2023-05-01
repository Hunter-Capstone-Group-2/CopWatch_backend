//
//  UserTablePatch.swift
//  
//
//  Created by Raul Camargo on 4/1/23.
//

import Vapor
import Fluent

struct UserTablePatch: Content
{
    var user_name: String
    var longitude: Double
    var latitude: Double
    var userID: String
}

