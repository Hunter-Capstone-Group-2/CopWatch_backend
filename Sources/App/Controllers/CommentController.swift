//
//  CommentController.swift
//  
//
//  Created by Raul Camargo on 4/5/23.
//

import Fluent
import Vapor

struct CommentTableController: RouteCollection
{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let comment = routes.grouped("comment")
        comment.get(use: index)
        comment.post(use: create)
    }
   
    func index(req: Request) async throws -> [Comment]
    {
        try await Comment.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus
    {
        let newComment = try req.content.decode(CommentTablePatch.self)
        let comment = Comment(
            pinID: newComment.pinID,
            userID: newComment.userID,
            comment: newComment.comment)
        try await comment.save(on: req.db)
        return .ok
    }
}
