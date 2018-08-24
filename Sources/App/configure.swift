import FluentPostgreSQL
import Vapor

public func configure(
  _ config: inout Config,
  _ env: inout Environment,
  _ services: inout Services
  ) throws {
  try services.register(FluentPostgreSQLProvider())

  let router = EngineRouter.default()
  try routes(router)
  services.register(router, as: Router.self)

  var middlewares = MiddlewareConfig()
  middlewares.use(ErrorMiddleware.self)
  services.register(middlewares)

  var databases = DatabasesConfig()
  let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
  let username = Environment.get("DATABASE_USER") ?? "vapor"
  let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
  let password = Environment.get("DATABASE_PASSWORD") ?? "password"

  let databaseConfig = PostgreSQLDatabaseConfig(hostname: hostname, username: username, database: databaseName, password: password)
  let database = PostgreSQLDatabase(config: databaseConfig)
  databases.add(database: database, as: .psql)
  services.register(databases)

  var migrations = MigrationConfig()
  migrations.add(model: User.self, database: .psql)
  migrations.add(model: Acronym.self, database: .psql)
  services.register(migrations)

  var commandConfig = CommandConfig.default()
  commandConfig.useFluentCommands()
  services.register(commandConfig)
}

