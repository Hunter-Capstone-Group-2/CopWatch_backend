//
//  PinTableController.swift
//  
//
//  Created by Raul Camargo on 4/3/23.
//

import Fluent
import Vapor
import FluentPostGIS

struct PinTableController: RouteCollection
{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let pin = routes.grouped("pin")
        pin.get(use: index)
        pin.post(use: create)
    }
    
    func index(req: Request) async throws -> [Pin]
    {
        try await Pin.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus
    {
        let newPin = try req.content.decode(PinTablePatch.self)
        let geoPT = GeographicPoint2D(longitude: newPin.longitude, latitude: newPin.latitude)
        let pin = Pin(
            userID: newPin.userID,
            confirmed: newPin.confirmed,
            pinLocation: geoPT)
        try await pin.save(on: req.db)
        return .ok
    }
}
