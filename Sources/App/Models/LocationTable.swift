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
    static let schema = "location"
    
    // Table columns
    @ID(custom: "location_id", generatedBy: .user)
    var id: String?
    
    @Field(key: "latitude")
    var latitude: Double
    
    @Field(key: "longitude")
    var longitude: Double
    
    @OptionalField(key: "building_number")
    var buildingNumber: String?
    
    @OptionalField(key: "street")
    var street: String?
    
    @OptionalField(key: "description")
    var description: String?
    
    @Children(for: \.$location) // Designates user as a relation
    var users: [User]
    
    init() { }
    
    init(id: String? = nil, lat: Double,long: Double,
         bldnum: String, street: String, desc: String)
        {
            self.id = id
            self.latitude = lat
            self.longitude = long
            self.buildingNumber = bldnum
            self.street = street
            self.description = desc
        }
    
}


