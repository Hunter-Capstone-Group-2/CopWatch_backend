//
//  20230421_DateToDatetime.swift
//
//  Change date format in pin and comment table to datetime
//
//  Created by Raul Camargo on 4/21/23.
//

import Fluent

struct ChangeDateToDatetime: AsyncMigration
{
    func prepare(on database: Database) async throws
    {
        // Change time created/confirmed column type from date to datetime in pin table
        try await database.schema("pin")
            .updateField("time_created", .datetime) // change column type from .date to .datetime
            .updateField("time_confirmed", .datetime) // change column type from .date to .datetime
            .update()
        
        // Change time created column type from date to datetime in comment table
        try await database.schema("comment")
            .updateField("time_created", .datetime)
            .update()
    } // End prepare
    
    func revert(on database: FluentKit.Database) async throws
    {
        try await database.schema("pin")
            .updateField("time_created", .date) // revert column type back to .date
            .updateField("time_confirmed", .date) // revert column type back to .date
            .update()
        
        try await database.schema("comment")
            .updateField("time_created", .date)
            .update()
    } // End revert
    

}

