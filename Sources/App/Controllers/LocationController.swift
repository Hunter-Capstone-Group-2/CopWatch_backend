//
//  LocationController.swift
//
//  User location routing logic
//
//  Created by Raul Camargo on 3/25/23.
//

import Fluent
import Vapor

struct LocationController: RouteCollection
{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let location = routes.grouped("location")
        location.get(use: index)
        location.post(use: create)
    }
    
    func index(req: Request) async throws -> [Location]
    {
        try await Location.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus
    {
        let newLoc = try req.content.decode(LocationTablePatch.self)
        let locale = Location(
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

