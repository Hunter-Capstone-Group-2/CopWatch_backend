//
//  UserController.swift
//  
//
//  Created by Raul Camargo on 3/14/23.
//

import Fluent
import Vapor

struct UserController: RouteCollection
{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let user = routes.grouped("user")
        user.get(use: index)
        user.post(use: create)
    }
    func index(req: Request) async throws -> [User]
    {
        try await User.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus
    {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        return .ok
    }
    
}
