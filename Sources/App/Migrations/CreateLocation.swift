//
//  CreateLocation.swift
//  
//  Actually creates location and user tables.
//  Created by Raul Camargo on 3/12/23.
//

import Fluent

struct CreateLocation: AsyncMigration
{
    func prepare(on database: Database) async throws
    {
        // create location table
        try await database.schema("location")
            .field("location_id", .string, .identifier(auto: false))
            .field("latitude", .double, .required )
            .field("longitude", .double, .required)
            .unique(on: "latitude", "longitude") // No repeat entries with same coordinates
            .field("building_number", .string)
            .field("street", .string)
            .field("description", .string)
            .create()
        
        // create user table
        try await database.schema("user")
            .field("user_id", .string, .identifier(auto: false))
            .field("user_name", .string, .required)
            .unique(on: "user_name") // No repeat usernames
            .field("location_id", .string, .required)
            .field("pins_created", .int)
            .field("pins_confirmed", .int)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("user").delete()
        try await database.schema("location").delete()
    }
}
