//
//  UserTable.swift
//
//
//  Created by Raul Camargo on 3/10/23.
//

import Vapor
import Fluent

final class User: Model {
    
    // Table name
    static let schema = "user"
    
    
    @ID(key: .id)
    var id: UUID?
    
    // Table columns
    @Field(key: "user_id")
    var user_id: String
    
    @Field(key: "user_name")
    var user_name: String

    @Field(key: "location_id")
    var location_id: String
    
    @Field(key: "pins_created")
    var pins_created: Int
    
    @Field(key: "pins_confirmed")
    var pins_confirmed: Int
    
    init() { }
    
    init(id: UUID? = nil, user_id: String, user_name: String,
         location_id: String, pins_created: Int, pins_confirmed: Int )
        {
            self.id = id
            self.user_id = user_id
            self.user_name = user_name
            self.location_id = location_id
            self.pins_created = pins_created
            self.pins_confirmed = pins_confirmed
        }
}
