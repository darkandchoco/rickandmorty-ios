import Foundation
import Combine

public protocol CharactersService: AnyObject {
    func getCharacters() -> AnyPublisher<[Character], Error>
}

public protocol CharactersClient: AnyObject {
    func getCharacters(page: Int?) -> AnyPublisher<[Character], Error>
}

public final class RemoteCharactersService: CharactersService {
    private let client: CharactersClient
    private let cacheService: CharactersCacheService
    
    public init(client: CharactersClient,
                cacheService: CharactersCacheService) {
        self.client = client
        self.cacheService = cacheService
    }
    
    public func getCharacters() -> AnyPublisher<[Character], any Error> {
        let cachedCharacters = cacheService.getCharacters()
        
        let cachedPublisher: AnyPublisher<[Character], any Error> = Just(cachedCharacters)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let fetchAllPagesPublisher: AnyPublisher<[Character], any Error> = fetchPages(1...20)
            .handleEvents(receiveOutput: { [weak self] characters in
                self?.cacheService.saveCharacters(characters)
            })
            .eraseToAnyPublisher()
        
        if !cachedCharacters.isEmpty {
            return cachedPublisher
                .append(fetchAllPagesPublisher)
                .eraseToAnyPublisher()
        } else {
            return fetchAllPagesPublisher
        }
    }
    
    private func fetchPages(_ range: ClosedRange<Int>) -> AnyPublisher<[Character], any Error> {
        let publishers = range.map { page in
            client.getCharacters(page: page)
        }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .map { $0.flatMap { $0 } } // Flatten arrays from each page
            .eraseToAnyPublisher()
    }
}

public protocol CharactersCacheService: AnyObject {
    func saveCharacters(_ characters: [Character])
    func getCharacters() -> [Character]
}
