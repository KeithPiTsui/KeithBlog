import Vapor
import Cookies
import HTTP
import FluentProvider

fileprivate weak var _drop: Droplet!

struct WebPageController {
  func addRoutes(to drop: Droplet) {
    _drop = drop
    let webPage = drop.grouped("web")
    webPage.get(handler: welcome)
    webPage.get("index", handler: indexPage)
  }
  
  
  func indexPage(_ req: Request) throws -> ResponseRepresentable {
    let greetings = ["Mundo", "Monde", "Welt"]
    return try _drop.view.make("hello", ["greeting": "World", "worlds": greetings.makeNode(in: nil)])
  }
  func welcome(_ req: Request) throws -> ResponseRepresentable {
    return try _drop.view.make("welcome",["message":"Keith"])
  }
}

