import Fluent
import FluentPostGIS
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(configuration: .init(hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                                                     username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
                                                     password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
                                                     database: Environment.get("DATABASE_NAME") ?? "vapor_database",
                                                     tls: .prefer(try .init(configuration: .clientDefault))
                                                    )
    ), as: .psql)

    // Table migrations
    app.migrations.add(EnablePostGISMigration())
    app.migrations.add(CreateUser())
    app.migrations.add(CreatePin())
    app.migrations.add(CreateComment())
    app.migrations.add(ChangeDateToDatetime())
    app.migrations.add(AddWhatWhatDetailWhatLocation())
    app.migrations.add(MakeUserSoftDeletable())
    
    try app.autoMigrate().wait()


    // register routes
    try routes(app)
}
