import Vapor
import FluentPostgreSQL

final class Acronym: Codable {
  var id: Int?
  var short: String
  var long: String
  var userID: User.ID

  init(short: String, long: String, userID: User.ID) {
    self.short = short
    self.long = long
    self.userID = userID
  }
}

extension Acronym: PostgreSQLModel { }

extension Acronym: Content { }

extension Acronym: Parameter { }

extension Acronym: Migration {
  static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
    return Database.create(self, on: connection) { builder in
      try addProperties(to: builder)
      builder.reference(from: \.userID, to: \User.id)
    }
  }
}


extension Acronym {
  var user: Parent<Acronym, User> { return parent(\.userID) }

  var categories: Siblings<Acronym, Category, AcronymCategoryPivot> { return siblings() }
}
