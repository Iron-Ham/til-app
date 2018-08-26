import Leaf
import Vapor

struct WebsiteController: RouteCollection {
  func boot(router: Router) throws {
    router.get(use: indexHandler)
    router.get("acronyms", Acronym.parameter, use: acronymHandler)
  }

  func indexHandler(_ req: Request) throws -> Future<View> {
    return Acronym.query(on: req)
      .all()
      .flatMap(to: View.self) { acronyms in
        let context = IndexContext(title: "Homepage", acronyms: acronyms)
        return try req.view().render("index", context)
      }
  }

  func acronymHandler(_ req: Request) throws -> Future<View> {
    return try req.parameters.next(Acronym.self)
      .flatMap(to: View.self) { acronym in
        return acronym.user
          .get(on: req)
          .flatMap(to: View.self) { user in
            let context = AcronymContext(title: acronym.short, acronym: acronym, user: user)
            return try req.view().render("acronym", context)
        }
    }
  }
}

struct IndexContext: Encodable {
  let title: String
  let acronyms: [Acronym]
}

struct AcronymContext: Encodable {
  let title: String
  let acronym: Acronym
  let user: User
}
