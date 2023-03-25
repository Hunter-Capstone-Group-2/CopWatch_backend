//
//  UserTablePatch.swift
//  
//
//  Created by Raul Camargo on 3/20/23.
//

import Vapor
import Fluent

struct UserTablePatch: Decodable
{
    var user_id: String?
    var user_name: String
    var location_id: Location.IDValue
    var pinsCreated : Int?
    var pinsConfirmed: Int?
}
