import Fluent
import FluentPostGIS
import FluentPostgresDriver
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    // Add HMAC with SHA-256 signer.
    //app.jwt.signers.use(.hs256(key: "secret"))
    
    // Migrations modifying db
    app.migrations.add(EnablePostGISMigration())
    app.migrations.add(CreateUser())
    app.migrations.add(CreatePin())
    app.migrations.add(CreateComment())
    app.migrations.add(ChangeDateToDatetime())
    
    try app.autoMigrate().wait()


    // register routes
    try routes(app)
}
