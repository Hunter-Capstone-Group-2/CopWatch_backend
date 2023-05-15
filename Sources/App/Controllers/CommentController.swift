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
        comment.get("userCommentCount", ":userID", use: totalCommentsbyUser)
        comment.put(use: editComment)
        comment.put("LikeDislike", use: changeLikeDislike)
        comment.delete(":id", use: delete)
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
    
    // GET // Returns comments made by a specific user. BaseURL/comment/byUser/{userID}
    func getUserPosts(req: Request) async throws -> [Comment]
    {
        let identifier = req.parameters.get("userID")!
        
        return try await Comment.query(on: req.db)
                .filter(\.$userID == identifier)
                .all()
    }
    
    // GET // Returns total comment count made by user. BaseURL/comment/totalCommentbyUser/{userID}
    func totalCommentsbyUser(req: Request) async throws -> Int
    {
        let identifier = req.parameters.get("userID")!
        
        let commentCount =  try await Comment.query(on: req.db)
                .filter(\.$userID == identifier)
                .all()
        
        return commentCount.count
    }
    
    // GET // Returns comments for a specific pin. BaseURL/comment/byPin/{pinID}
    func getPinPosts(req: Request) async throws -> [Comment]
    {
        let identifier = req.parameters.get("pinID", as: UUID.self)!
        
        return try await Comment.query(on: req.db)
                .filter(\.$pinID.$id == identifier)
                .all()
    }
    
    // PUT // Edits existing comment. BaseURL/comment/
    func editComment(req: Request) async throws -> HTTPStatus
    {
        let newComment = try req.content.decode(CommentTableEdit.self)
        
        guard let dbCommentEntry = try await Comment.find(newComment.id, on: req.db)
        else
        {
            throw Abort(.notFound)
        }
        
        dbCommentEntry.comment = newComment.comment
        dbCommentEntry.like = newComment.like
        dbCommentEntry.dislike = newComment.dislike
        
        try await dbCommentEntry.update(on: req.db)
        
        return .ok
    }
    
    // PUT // Changes like / dislike value by +- 1. BaseURL/LikeDislike
    func changeLikeDislike(req: Request) async throws -> Comment
    {
        // Error checks
        let changeValues = try req.content.decode(CommentTableEdit.self)
        guard let comment = try await Comment.find(changeValues.id, on: req.db)
        else
        {
            throw Abort(.notFound)
        }
        // Like and Dislike can not both be incremented or decremented at the same time.
        if ((changeValues.like == 1) && (changeValues.dislike == 1)) || ((changeValues.like == -1) && (changeValues.dislike == -1))
        {
            throw Abort(.conflict, reason: "Can't have two equal non-zero values.")
        }
        
        // Add +- 1 to existing db value
        let oldLike = comment.like ?? 0
        let oldDislike = comment.dislike ?? 0
        let newLike = oldLike + changeValues.like
        let newDislike = oldDislike + changeValues.dislike
    
        comment.like = newLike
        comment.dislike = newDislike
        try await comment.update(on: req.db)
        
        return comment
    }
    
    // DELETE // Deletes comment based on comment id. BaseURL/comment/{id}
    func delete(req: Request) async throws -> HTTPStatus
    {
        guard let id = req.parameters.get("id", as: UUID.self)
        else
        {
            throw Abort(.badRequest, reason: "Invalid parameter type.")
        }
        guard let comment = try await Comment.find(id, on: req.db)
        else
        {
               throw Abort(.notFound)
        }
        try await comment.delete(on: req.db)
        return .ok
    }
    
}
