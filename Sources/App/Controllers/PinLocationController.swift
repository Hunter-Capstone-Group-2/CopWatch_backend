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
        let pinLocation = routes.grouped("pin_location")
        pinLocation.get(use: index)
        pinLocation.post(use: create)
    }
    
    func index(req: Request) async throws -> [PinLocation]
    {
        try await PinLocation.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus
    {
        let newPin = try req.content.decode(PinLocationTablePatch.self)
        let locale = PinLocation(
            id: newPin.location_id,
            lat: newPin.latitude,
            long: newPin.longitude,
            bldnum: newPin.building_number ?? "NONE",
            street: newPin.street ?? "NONE",
            desc: newPin.description ?? " "
        )

        try await locale.save(on: req.db)
        return .ok
    }
    
}
