import Fluent
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  // Basic "Hello, world!" example
  router.get("hello") { req in
    return "Hello, world!"
  }
  
  let acronymController = AcronymController()
  try router.register(collection: acronymController)
}
