//
//  20230401_User.swift
//  Create user table
//
//  Created by Raul Camargo on 4/1/23.
//
import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws
    {
        
        try await database.schema("user")
            .field("user_id", .string, .identifier(auto: false))
            .field("user_name", .string, .required)
            .field("location", .geographicPoint2D, .required)
            .unique(on: "user_name", name: "no_duplicate_names")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("user").delete()
    }
}
