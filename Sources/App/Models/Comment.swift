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
    // User relation will be foreign key.
    @Field(key: "user_id")
    var userID: String
    
    @Timestamp(key: "time_created", on: .create)
    var created: Date?
    
    @Field(key: "comment")
    var comment: String
    
    @OptionalField(key: "like")
    var like: Int?
    
    @OptionalField(key: "dislike")
    var dislike: Int?
    
    init() {}
    
    init(id: UUID? = nil, pinID: UUID, userID: String, comment: String)
    {
        self.id = id
        self.$pinID.id = pinID
        self.userID = userID
        self.comment = comment
    }
    
    
}
