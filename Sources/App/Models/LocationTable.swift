//
//  LocationTable.swift
//  
//
//  Created by Raul Camargo on 3/17/23.
//

import Vapor
import Fluent

final class Location: Model, Content
{
    public static let schema = "location"
    
    // Table columns
    @ID(custom: "user_id", generatedBy: .user)
    var id: String?
    
    @Field(key: "user_name")
    var userName: String

//    @Field(key: "location_id")
//    var locationID: String
    
    @OptionalField(key: "pins_created")
    var pinsCreated : Int?
    
    @OptionalField(key: "pins_confirmed")
    var pinsConfirmed: Int?
    
    init() { }
    
    init(id: String? = nil, userName: String,
         pinsCreated: Int, pinsConfirmed: Int )
        {
            self.id = id
            self.userName = userName
            //self.location_id = location_id
            self.pinsCreated = pinsCreated
            self.pinsConfirmed = pinsConfirmed
        }
    
}


