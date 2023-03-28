//
//  Mar262023.swift
//
//  Create PinLocation table
//
//  Created by Raul Camargo on 3/12/23.
//

import Fluent

struct CreatePinLocation: AsyncMigration
{
    func prepare(on database: FluentKit.Database) async throws
    {
        try await database.schema("pin_location")
            .field("pin_location_id", .string, .identifier(auto: false))
            .field("latitude", .double, .required )
            .field("longitude", .double, .required)
            .unique(on: "latitude", "longitude") // No repeat entries with same coordinates
            .field("building_number", .string)
            .field("street", .string)
            .field("description", .string)
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws
    {
        try await database.schema("pin_location").delete()
    }
    
}
