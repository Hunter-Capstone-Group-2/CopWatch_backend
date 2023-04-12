import Fluent
import Vapor
import FluentPostGIS

struct UserTableController: RouteCollection
{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let user = routes.grouped("user")
        user.get(use: index)
        user.post(use: create)
        user.delete(":userID", use: delete)
    }
    
    func index(req: Request) async throws -> [User]
    {
        try await User.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> String
    {
        // Generate random id with uuid converted to base64 string
        let uuid = UUID()
        let idString = withUnsafeBytes(of: uuid.uuid) {Data($0)}
        let encodedID = idString.base64EncodedString()
        
        let newUser = try req.content.decode(UserTablePatch.self)
        let geoPt = GeographicPoint2D(longitude: newUser.longitude, latitude: newUser.latitude)
        let user = User(
            id: encodedID,
            name: newUser.user_name,
            location: geoPt)
            
            try await user.save(on: req.db)
        return user.id ?? "Error. UserID not created."
    }
    
    func delete(req: Request) async throws -> HTTPStatus
    {
        guard let id = req.parameters.get("userID", as: String.self)
        else
        {
            throw Abort(.badRequest, reason: "Invalid parameter.")
        }
        let user = try await User.find(id, on: req.db)
           guard let existingUser = user
        else
        {
               throw Abort(.notFound)
        }
           try await existingUser.delete(on: req.db)
           return .noContent
    }
}
