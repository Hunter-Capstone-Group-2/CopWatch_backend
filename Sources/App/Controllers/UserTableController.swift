import Fluent
import Vapor
import FluentPostGIS

struct UserTableController: RouteCollection
{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let user = routes.grouped("user")
        user.get(use: index)
        user.post(use: create)
        user.put(use: update)
        user.delete(":userID", use: delete)
    }
    
    // GET // Returns all users, probably never going to use. BaseURL/user
    func index(req: Request) async throws -> [User]
    {
        try await User.query(on: req.db).all()
    }
    
    // POST // Creates new user and returns userID. BaseURL/user
    func create(req: Request) async throws -> String
    {
        // Generate random id with uuid converted to base64 string
        let uuid = UUID()
        let idString = withUnsafeBytes(of: uuid.uuid) {Data($0)}
        let encodedID = idString.base64EncodedString()
        
        let newUser = try req.content.decode(UserTablePatch.self)
        let geoPt = GeographicPoint2D(longitude: newUser.longitude, latitude: newUser.latitude)
        
        // Check if username exists and return error if so.
        let nameTaken = try await User.nameInUse(newUser.user_name, on: req.db)
        if nameTaken
        {
            throw Abort(.conflict, reason: "User name is already in use")
        }
        
        
        let user = User(
            id: encodedID,
            name: newUser.user_name,
            location: geoPt)
            
            try await user.save(on: req.db)
        return user.id ?? "Error. UserID not created."
    }
    
    // PUT // Updates user data (name or location). BaseURL/user
    func update(req: Request) async throws -> HTTPStatus
    {
        let user = try req.content.decode(UserTablePatch.self)

        guard let dbUserEntry = try await User.find(user.userID, on: req.db)
        else
        {
            throw Abort(.notFound)
        }
        
        // Check if username exists and return error if so.
        let nameTaken = try await User.nameInUse(user.user_name, on: req.db)
        if nameTaken
        {
            throw Abort(.conflict, reason: "User name is already in use")
        }
        
        let geoPt = GeographicPoint2D(longitude: user.longitude, latitude: user.latitude)
        dbUserEntry.userName = user.user_name
        dbUserEntry.location = geoPt
        try await dbUserEntry.update(on: req.db)
        return .ok
    }
    
    // DELETE // Deletes user based on userID. BaseURL/user/userID
    func delete(req: Request) async throws -> HTTPStatus
    {
        guard let id = req.parameters.get("userID", as: String.self)
        else
        {
            throw Abort(.badRequest, reason: "Invalid parameter type.")
        }
        guard let user = try await User.find(id, on: req.db)
        else
        {
               throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .ok
    }
}
