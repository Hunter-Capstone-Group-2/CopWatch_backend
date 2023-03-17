//
//  CreateUser.swift
//  
//
//  Created by Raul Camargo on 3/12/23.
//

import Fluent

struct CreateUser: AsyncMigration
{
    func prepare(on database: Database) async throws
    {
        try await database.schema("user")
            .field("user_id", .string, .identifier(auto: false))
            .unique(on: "user_id")
            .field("user_name", .string, .required)
            .unique(on: "user_name")
            //.foreignKey("location_id", references: "location", "location_id")
            .field("pins_created", .int)
            .field("pins_confirmed", .int)
            .create()
    }
    
    func revert(on database: Database) async throws
    {
        try await database.schema("user").delete()
    }
}
