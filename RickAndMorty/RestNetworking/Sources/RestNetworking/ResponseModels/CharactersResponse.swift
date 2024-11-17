//
//  CharactersResponse.swift
//  RestNetworking
//
//  Created by Richmond and Loren on 2024-11-17.
//
import CommonCore

struct CharactersResponse: Codable {
    let info: Info
    let results: [Character]
    
    func toDomainModel() -> [CommonCore.Character] {
        return results.map({
            return CommonCore.Character(id: $0.id,
                                        name: $0.name,
                                        status: $0.status,
                                        species: $0.species,
                                        type: $0.type,
                                        gender: $0.gender,
                                        origin: $0.origin.name,
                                        location: $0.location.name,
                                        image: $0.image)
        })
    }
}

struct Info: Codable {
    let count, pages: Int
    let next: String
    let prev: Int?
}

struct Character: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Codable {
    let name: String
    let url: String
}
