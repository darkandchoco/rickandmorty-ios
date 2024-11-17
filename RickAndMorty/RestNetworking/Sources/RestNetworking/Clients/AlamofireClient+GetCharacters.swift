//
//  AlamofireClient+GetCharacters.swift
//  RestNetworking
//
//  Created by Richmond and Loren on 2024-11-17.
//
import CommonCore
import Combine
import Foundation

extension AlamofireClient: CharactersClient {
    public func getCharacters() -> AnyPublisher<[CommonCore.Character], any Error> {
        Deferred {
            Future<[CommonCore.Character], Error> { [weak self] promise in
                guard let self = self else {
                    promise(.failure(RequestManager.RequestError.selfDeallocated))
                    return
                }
                self.requestManager.request(RickAndMortyRouter.getCharacters) { (result: Result<CharactersResponse, Error>) in
                    switch result {
                    case .success(let response):
                        promise(.success(response.toDomainModel()))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Welcome
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
                             gender: $0.gender)
        })
    }
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: String
    let prev: Int?
}

// MARK: - Result
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

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}
