//
//  PinLocationController.swift
//  
//  Pin location routing logic
//
//  Created by Raul Camargo on 3/27/23.
//

import Fluent
import Vapor

struct PinLocationController: RouteCollection
{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let location = routes.grouped("pin_location")
        location.get(use: index)
        location.post(use: create)
    }
    
    func index(req: Request) async throws -> [PinLocation]
    {
        try await PinLocation.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus
    {
        let newLoc = try req.content.decode(LocationTablePatch.self)
        let locale = PinLocation(
            id: newLoc.location_id,
            lat: newLoc.latitude,
            long: newLoc.longitude,
            bldnum: newLoc.building_number ?? "NONE",
            street: newLoc.street ?? "NONE",
            desc: newLoc.description ?? " "
        )

        try await locale.save(on: req.db)
        return .ok
    }
    
}
