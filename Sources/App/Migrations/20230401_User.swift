import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws
    {
        // Create user table
        try await database.schema("user")
            .field("user_id", .string, .identifier(auto: true))
            .field("user_name", .string, .required)
            .field("location", .geographicPoint2D, .required)
            .unique(on: "user_name")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("user").delete()
    }
}
