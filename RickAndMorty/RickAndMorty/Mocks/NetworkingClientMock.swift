//
//  NetworkingClientMock.swift
//  RickAndMorty
//
//  Created by Richmond Ko on 2024-11-15.
//

import Foundation
import CommonCore
import Combine

final class NetworkingClientMock: CharactersClient {
    func getCharacters() -> AnyPublisher<[Character], any Error> {       
        return Deferred { Future<[Character], Error> { promise in
                promise(.success([
                    Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender"),
                    Character(id: 2, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender"),
                    Character(id: 3, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender")
                ]))
            }
        }.eraseToAnyPublisher()
    }
}
