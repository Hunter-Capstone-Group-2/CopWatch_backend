//
//  PinTableController.swift
//  
//
//  Created by Raul Camargo on 4/3/23.
//

import Fluent
import Vapor

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
        let pin = try req.content.decode(Pin.self)
        try await pin.save(on: req.db)
        return .ok
    }
}
