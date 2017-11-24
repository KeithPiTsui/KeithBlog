import Vapor
import FluentProvider
import HTTP

final class Pet: Model {
  let storage = Storage()
  
  // MARK: Properties and database keys
  
  /// The content of the post
  var owner_id: Identifier?
  var name: String
  var type: String
  
  /// The column names for `id` and `content` in the database
  struct Keys {
    static let id = "id"
    static let owner_id = "owner_id"
    static let name = "name"
    static let type = "type"
  }
  
  /// Creates a new Post
  init(owner_id: Identifier?, name: String, type: String) {
    self.owner_id = owner_id
    self.name = name
    self.type = type
  }
  
  // MARK: Fluent Serialization
  
  /// Initializes the Post from the
  /// database row
  init(row: Row) throws {
    owner_id = try row.get(Pet.Keys.owner_id)
    name = try row.get(Pet.Keys.name)
    type = try row.get(Pet.Keys.type)
  }
  
  // Serializes the Post to the database
  func makeRow() throws -> Row {
    var row = Row()
    try row.set(Pet.Keys.owner_id, owner_id)
    try row.set(Pet.Keys.name, name)
    try row.set(Pet.Keys.type, type)
    return row
  }
}

// MARK: Fluent Preparation

extension Pet: Preparation {
  /// Prepares a table/collection in the database
  /// for storing Posts
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string(Pet.Keys.name)
      builder.string(Pet.Keys.type)
      builder.parent(User.self, optional: false, unique: true, foreignIdKey: Pet.Keys.owner_id)
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
extension Pet: JSONConvertible {
  convenience init(json: JSON) throws {
    self.init(
      owner_id: try json.get(Pet.Keys.owner_id),
      name: try json.get(Pet.Keys.name),
      type: try json.get(Pet.Keys.type)
    )
  }
  
  func makeJSON() throws -> JSON {
    var json = JSON()
    try json.set(Pet.Keys.id, id)
    try json.set(Pet.Keys.owner_id, owner_id)
    try json.set(Pet.Keys.name, name)
    try json.set(Pet.Keys.type, type)
    return json
  }
}

// MARK: HTTP

// This allows Post models to be returned
// directly in route closures
extension Pet: ResponseRepresentable { }

// MARK: Update

// This allows the Post model to be updated
// dynamically by the request.
extension Pet: Updateable {
  // Updateable keys are called when `post.update(for: req)` is called.
  // Add as many updateable keys as you like here.
  public static var updateableKeys: [UpdateableKey<Pet>] {
    return [
      // If the request contains a String at key "content"
      // the setter callback will be called.
      UpdateableKey(Pet.Keys.owner_id, Identifier?.self) { pet, owner_id in
        pet.owner_id = owner_id
      },
      UpdateableKey(Pet.Keys.name, String.self) { pet, name in
        pet.name = name
      },
      UpdateableKey(Pet.Keys.type, String.self) { pet, type in
        pet.type = type
      }
    ]
  }
}

extension Pet {
  var owner: Parent<Pet, User> {
    return parent(id: owner_id)
  }
}

