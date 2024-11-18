import Foundation
import CommonCore
import Combine

final class NetworkingClientMock: CharactersClient {
    func getCharacters(page: Int?) -> AnyPublisher<[Character], any Error> {       
        return Deferred { Future<[Character], Error> { promise in
                promise(.success([
                    Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something"),
                    Character(id: 2, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something"),
                    Character(id: 3, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something")
                ]))
            }
        }.eraseToAnyPublisher()
    }
}
