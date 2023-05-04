//
//  20230503_Pin+What+DetailWhat+LocationDescription.swift
//  
//  Add What happened + Description + Location address/desc
//
//  Created by Raul Camargo on 5/3/23.
//

import Fluent

struct AddWhatWhatDetailWhatLocation: AsyncMigration
{
    func prepare(on database: Database) async throws
    {
        try await database.schema("pin")
            .field("report", .string)
            .field("report_detail", .string)
            .field("report_location", .string)
            .update()
    }
    
    func revert(on database: Database) async throws
    {
        try await database.schema("pin")
            .deleteField("what_reporting")
            .deleteField("report_detail")
            .deleteField("report_location")
            .update()
    }
}
