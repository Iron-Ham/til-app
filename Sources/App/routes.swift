import Fluent
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  // Basic "Hello, world!" example
  router.get("hello") { req in
    return "Hello, world!"
  }
  
  let acronymsController = AcronymsController()
  try router.register(collection: acronymsController)

  let usersController = UsersController()
  try router.register(collection: usersController)

  let categoriesController = CategoriesController()
  try router.register(collection: categoriesController)
}
