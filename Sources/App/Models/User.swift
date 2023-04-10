//
//  User.swift
//  
//
//  Created by Raul Camargo on 4/1/23.
//

import Vapor
import Fluent
import FluentPostGIS

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
    
    @Field(key: "location")
    var location: GeographicPoint2D
    
    @Children(for: \.$userID) // Sets relation to pin table.
    var pins: [Pin]
    
    init() {}
    
    init(id: String? = nil, name: String, location: GeographicPoint2D)
    {
        self.id =  id
        self.userName = name
        self.location = location
    }
}
