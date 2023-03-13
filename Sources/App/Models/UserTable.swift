//
//  UserTable.swift
//
//
//  Created by Raul Camargo on 3/10/23.
//

import Vapor
import Fluent

final class User: Model {
    
    typealias IDValue = String
    
    // Table name
    static let schema = "user"
    
    // Table columns
    @ID(custom: "user_id", generatedBy: .user)
    var id: String?
    
    @Field(key: "user_name")
    var user_name: String

    @Field(key: "location_id")
    var location_id: String
    
    @OptionalField(key: "pins_created")
    var pins_created : Int?
    
    @OptionalField(key: "pins_confirmed")
    var pins_confirmed: Int?
    
    init() { }
    
    init(id: UUID? = nil, user_id: String, user_name: String,
         location_id: String, pins_created: Int, pins_confirmed: Int )
        {
            self.user_id = user_id
            self.user_name = user_name
            self.location_id = location_id
            self.pins_created = pins_created
            self.pins_confirmed = pins_confirmed
        }
}
