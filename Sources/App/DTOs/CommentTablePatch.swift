//
//  CommentTablePatch.swift
//  
//
//  Created by Raul Camargo on 4/10/23.
//

import Vapor
import Fluent

struct CommentTablePatch: Content
{
    var pinID: UUID
    var userID: String
    var comment: String
    var id: UUID
    var like: Int
    var dislike: Int
}
