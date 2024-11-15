import Foundation
import Combine

public protocol CharactersService: AnyObject {
    func getCharacters() -> AnyPublisher<[Character], Error>
}

public protocol CharactersClient: AnyObject {
    func getCharacters() -> AnyPublisher<[Character], Error>
}

public final class RemoteCharactersService: CharactersService {
    private let client: CharactersClient
    
    public init(client: CharactersClient) {
        self.client = client
    }
    
    public func getCharacters() -> AnyPublisher<[Character], any Error> {
        return client.getCharacters()
    }
}
