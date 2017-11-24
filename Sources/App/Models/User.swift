import Vapor
import FluentProvider
import HTTP

final class User: Model {
  let storage = Storage()
  
  // MARK: Properties and database keys
  
  /// The name of the user
  var name: String
  
  /// The column names for `id` and `content` in the database
  struct Keys {
    static let id = "id"
    static let name = "name"
  }
  
  /// Creates a new Post
  init(name: String) {
    self.name = name
  }
  
  // MARK: Fluent Serialization
  
  /// Initializes the Post from the
  /// database row
  init(row: Row) throws {
    name = try row.get(User.Keys.name)
  }
  
  // Serializes the Post to the database
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(User.Keys.name, name)
    return row
  }
}

// MARK: Fluent Preparation

extension User: Preparation {
  /// Prepares a table/collection in the database
  /// for storing Posts
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(User.Keys.name)
    }
  }
  
  /// Undoes what was done in `prepare`
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new Post (POST /posts)
//     - Fetching a post (GET /posts, GET /posts/:id)
//
extension User: JSONConvertible {
  convenience init(json: JSON) throws {
    self.init(
      name: try json.get(User.Keys.name)
    )
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(User.Keys.id, id)
    try json.set(User.Keys.name, name)
    return json
  }
}

// MARK: HTTP

// This allows Post models to be returned
// directly in route closures
extension User: ResponseRepresentable { }

// MARK: Update

// This allows the Post model to be updated
// dynamically by the request.
extension User: Updateable {
  // Updateable keys are called when `post.update(for: req)` is called.
  // Add as many updateable keys as you like here.
  public static var updateableKeys: [UpdateableKey<User>] {
    return [
      UpdateableKey(User.Keys.name, String.self) { User, name in
        User.name = name
      }
    ]
  }
}



extension User {
  var pets: Children<User, Pet> {
    return children(type: Pet.self, foreignIdKey: Pet.Keys.owner_id)
  }
}


