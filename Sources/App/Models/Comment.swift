//
//  Comment.swift
//  
//
//  Created by Raul Camargo on 4/4/23.
//

import Vapor
import Fluent

final class Comment: Model, Content
{
    typealias IDValue = UUID
    
    // Table name
    static let schema = "comment"
    
    // Columns
    @ID
    var id: UUID?
    
    @Parent(key: "pin_id")
    var pinID: Pin
    
    @
    
    
    
}
