import Vapor
import FluentProvider

struct ServerController {
  func addRoutes(to drop: Droplet) {
    let userGroup = drop.grouped("api", "server")
    userGroup.get(handler: allInfo)
  }
  
  
  func allInfo(_ req: Request) throws -> ResponseRepresentable {
    if let info = try User.database?.raw("show tables") {
      return info.wrapped.description
    } else {
      return "unknow error"
    }
    
  }
  
  
}
