//
//  CommentTablePatch.swift
//  DTO to deal with differences in naming conventions between JSON and Swift
//  DTO to account for differences in JSON payload between new comment and edited comment
//  Created by Raul Camargo on 4/10/23.
//

import Vapor
import Fluent

struct CommentTablePatch: Content
{
    var pinID: UUID
    var userID: String
    var comment: String
    
    var like: Int
    var dislike: Int
}

struct CommentTableEdit: Content
{
    var pinID: UUID
    var userID: String
    var comment: String
    var id: UUID
    var like: Int
    var dislike: Int
}
