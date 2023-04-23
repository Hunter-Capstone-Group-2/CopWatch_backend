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
        comment.get("byUser", ":userID", use: getUserPosts)
        comment.get("byPin", ":pinID", use: getPinPosts)
    }
   
    // GET // Returns ALL comments in table. BaseURL/comment
    func index(req: Request) async throws -> [Comment]
    {
        try await Comment.query(on: req.db).all()
    }
    
    // POST // Creates new comment. BaseURL/comment
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
    
    // GET // Returns all comments made by a specific user. BaseURL/comment/byUser/{userID}
    func getUserPosts(req: Request) async throws -> [Comment]
    {
        let identifier = req.parameters.get("userID")!
        
        return try await Comment.query(on: req.db)
                .filter(\.$userID == identifier)
                .all()
    }
    
    // GET // Returns all comments for a specific pin. BaseURL/comment/byPin/{pinID}
    func getPinPosts(req: Request) async throws -> [Comment]
    {
        let identifier = req.parameters.get("pinID", as: UUID.self)!
        
        return try await Comment.query(on: req.db)
                .filter(\.$pinID.$id == identifier)
                .all()
    }
    
}
