//
//  20230405_Comment.swift
//  
//  Create comment table
//  Created by Raul Camargo on 4/5/23.
//

import Fluent

struct CreateComment: AsyncMigration
{
    func prepare(on database: Database) async throws {
        
        try await database.schema("comment")
            .id()
            .field("pin_id", .uuid, .required, .references("pin", "id", onDelete: .cascade)) //
            .field("user_id", .string, .references("user", "user_id", onDelete: .setNull))
            .field("time_created", .date)
            .field("comment", .string)
            .field("like", .int)
            .field("dislike", .int)
            .create()
    }
    func revert(on database: Database) async throws {
        try await database.schema("comment").delete()
    }
    
    
}
