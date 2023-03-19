//
//  UserTable.swift
//
//
//  Created by Raul Camargo on 3/10/23.
//

import Vapor
import Fluent

final class User: Model, Content
{
    typealias IDValue = String
    
    // Table name
    static let schema = "user"
    
    // Table columns
    @ID(custom: "user_id", generatedBy: .user)
    var id: String?
    
    @Field(key: "user_name")
    var userName: String

    @Parent(key: "location_id")
    var location: Location
    
    @OptionalField(key: "pins_created")
    var pinsCreated : Int?
    
    @OptionalField(key: "pins_confirmed")
    var pinsConfirmed: Int?
    
    init() { }
    
    init(id: String? = nil, userName: String, loc: Location.IDValue,
         pinsCreated: Int, pinsConfirmed: Int )
        {
            self.id = id
            self.userName = userName
            self.$location.id = loc
            self.pinsCreated = pinsCreated
            self.pinsConfirmed = pinsConfirmed
        }
    
}

