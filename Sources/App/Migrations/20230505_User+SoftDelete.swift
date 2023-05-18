//
//  20230505_User+SoftDelete.swift
//  Allows for user to delete account without affecting child data (pins)
//
//  Created by Raul Camargo on 5/5/23.
//

import Fluent

struct MakeUserSoftDeletable: AsyncMigration
{
    func revert(on database: FluentKit.Database) async throws
    {
        try await database.schema("user")
            .deleteField("deleted_at")
            .update()
    }
    
    func prepare(on database: FluentKit.Database) async throws
    {
        try await database.schema("user")
            .field("deleted_at", .datetime)
            .update()
    }
    
    
}
