import Vapor
import Cookies
import HTTP
import FluentProvider

struct CookiesController {
  func addRoutes(to drop: Droplet) {
    let cookies = drop.grouped("cookies")
    cookies.get("create", handler: createCookies)
    cookies.get("delete", handler: deleteCookies)
    cookies.get("show", handler: showCookies)
    cookies.get("rd", handler: rdCookies)
  }
  
  func rdCookies(_ req: Request) throws -> ResponseRepresentable {
    let cookies = req.cookies
    let userCookie = cookies.first { (cookie) -> Bool in
      cookie.name == "user"
    }
    let user = userCookie?.value ?? "null"
    return Response(redirect: "SFAuthenticationSessionExample://?user=\(user)")
  }
  
  
  
  func createCookies(_ req: Request) throws -> ResponseRepresentable {
    let response = Response(status: .ok)
    let expiry = Date(timeIntervalSinceNow: 60)
    let cookie = Cookie(name: "user", value: UUID().uuidString, expires: expiry)
    response.cookies.insert(cookie)
    return response
  }
  
  func deleteCookies(_ req: Request) throws -> ResponseRepresentable {
    let response = Response(status: .ok)
    let expiry = Date(timeIntervalSinceNow: -60)
    let cookie = Cookie(name: "user", value: "", expires: expiry)
    response.cookies.insert(cookie)
    return response
  }
  
  func showCookies(_ req: Request) throws -> ResponseRepresentable {
    return "\(req.cookies)".makeResponse()
  }
  
}
