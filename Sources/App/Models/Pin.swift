//
//  Pin.swift
//  
//
//  Created by Raul Camargo on 4/2/23.
//

import Vapor
import Fluent
import FluentPostGIS

final class Pin: Model, Content
{
    typealias IDValue = UUID
    // Table name
    static let schema = "pin"
    
    // Table Columns
    @ID
    var id: UUID?
    
    @Parent(key: "user_id") // sets relation to user table
    var userID: User
    
    @Timestamp(key:"time_created", on: .create, format: .default)
    var timeCreateed: Date?
    
    @Timestamp(key:"time_confirmed", on: .update, format: .default)
    var timeConfirmed: Date?
    
    @Boolean(key:"confirmed")
    var confirmed: Bool
    
    @Field(key: "pin_location")
    var pinLocation: GeographicPoint2D
    
    @Children(for: \.$pinID)
    var comments: [Comment]
    
    init() {}
    
    init(id: UUID? = nil, userID: String, confirmed: Bool?, pinLocation: GeographicPoint2D)
    {
        self.id = id
        self.$userID.id = userID
        self.confirmed = confirmed ?? false
        self.pinLocation = pinLocation
    }
}
