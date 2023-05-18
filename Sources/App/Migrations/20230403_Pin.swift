//
//  20230403_Pin.swift
//  Create pin table
//
//  Created by Raul Camargo on 4/3/23.
//

import Fluent

struct CreatePin: AsyncMigration
{
    func prepare(on database: Database) async throws {
        
        try await database.schema("pin")
            .id()
            .field("user_id", .string, .required, .references("user", "user_id", onDelete: .setNull))
            .field("time_created", .date)
            .field("time_confirmed", .date)
            .field("confirmed", .bool)
            .field("pin_location", .geographicPoint2D)
            .create()
    }
    func revert(on database: Database) async throws {
        try await database.schema("pin").delete()
    }
}
