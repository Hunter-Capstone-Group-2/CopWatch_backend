import Fluent
import Vapor

struct UserTableController: RouteCollection
{
    func boot(routes: Vapor.RoutesBuilder) throws {
        let user = routes.grouped("user")
        user.get(use: index)
        user.post(use: create)
    }
    
    func index(req: Request) async throws -> [User]
    {
        try await User.query(on: req.db).all()
    }
    
    func create(req: Request) async throws -> HTTPStatus
    {
        let newUser = try req.content.decode(UserTablePatch.self)
        let user = User(
            name: newUser.user_name,
            location: newUser.user_location)
        
        try await user.save(on: req.db)
        return .ok
    }
}
