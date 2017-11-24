//
//  UserPetController.swift
//  App
//
//  Created by Keith on 24/11/2017.
//

import Vapor
import FluentProvider

struct UserPetController {
  func addRoutes(to drop: Droplet) {
    let userGroup = drop.grouped("api", "users")
    userGroup.post("create", handler: createUser)
    userGroup.get(handler: allUsers)
    userGroup.get(User.parameter, handler: getUser)
    
    let petGroup = drop.grouped("api", "pets")
    petGroup.post("create", handler: createPet)
    petGroup.get(handler: allPets)
    petGroup.get(Pet.parameter, handler: getPet)
    
    let petOwnerGroup = drop.grouped("api", "petownedbyuser")
    petOwnerGroup.get(User.parameter, handler: getPetsOwnedByUser)
  }
  
  func createUser(_ req: Request) throws -> ResponseRepresentable {
    guard let json = req.json else {
      throw Abort.badRequest
    }
    let user = try User(json: json)
    try user.save()
    return user
  }
  
  func allUsers(_ req: Request) throws -> ResponseRepresentable {
    let users = try User.all()
    return try users.makeJSON()
  }
  
  func getUser(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.parameters.next(User.self)
    return user
  }
  
  func createPet(_ req: Request) throws -> ResponseRepresentable {
    guard let json = req.json else {
      throw Abort.badRequest
    }
    let pet = try Pet(json: json)
    try pet.save()
    return pet
  }
  
  func allPets(_ req: Request) throws -> ResponseRepresentable {
    let pets = try Pet.all()
    return try pets.makeJSON()
  }
  
  func getPet(_ req: Request) throws -> ResponseRepresentable {
    let pet = try req.parameters.next(Pet.self)
    return pet
  }
  
  func getPetsOwnedByUser(_ req: Request) throws -> ResponseRepresentable {
    let user = try req.parameters.next(User.self)
    return try user.pets.all().makeJSON()
  }
}
