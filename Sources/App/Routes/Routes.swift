import Vapor

extension Droplet {
  func setupRoutes() throws {
    RemindersController().addRoutes(to: self)
    UserPetController().addRoutes(to: self)
    ServerController().addRoutes(to: self)
    WebPageController().addRoutes(to: self)
  }
}
