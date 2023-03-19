import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    // ignore case
    app.routes.caseInsensitive = true
    
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    // Add /user to routes
    try app.register(collection: UserController())
    
}
