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
    }
    func index(req: Request) throws -> EventLoopFuture<[User]>
    {
        return User.query(on: req.db).all()
    }
    
}
