import Foundation
import Combine
import RealmSwift

public protocol CharactersService: AnyObject {
    func getCharacters() -> AnyPublisher<[Character], Error>
}

public protocol CharactersClient: AnyObject {
    func getCharacters() -> AnyPublisher<[Character], Error>
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
        // Get cached characters first
        let cachedCharacters = cacheService.getCharacters()
        
        // Return cached characters immediately (if any)
        let cachedPublisher: AnyPublisher<[Character], any Error> = Just(cachedCharacters)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // Fetch fresh characters from client and update the cache
        let fetchAndUpdatePublisher: AnyPublisher<[Character], any Error> = client.getCharacters()
            .handleEvents(receiveOutput: { [weak self] characters in
                // Save the updated characters to cache
                self?.cacheService.saveCharacters(characters)
            })
            .map { [weak self] _ in
                // Return updated characters from cache
                return self?.cacheService.getCharacters() ?? []
            }
            .eraseToAnyPublisher()
        
        // Combine both publishers: return cached first, then update
        if !cachedCharacters.isEmpty {
            return cachedPublisher
                .append(fetchAndUpdatePublisher)
                .eraseToAnyPublisher()
        } else {
            // No cache available, fetch from client directly
            return fetchAndUpdatePublisher
        }
    }
}

public protocol CharactersCacheService: AnyObject {
    func saveCharacters(_ characters: [Character])
    func getCharacters() -> [Character]
}

public final class CharactersCacheServiceImplementation: CharactersCacheService {
    private let realm = try! Realm()
    
    public init() {
        
    }
    
    public func saveCharacters(_ characters: [Character]) {
        let realmCharacters = characters.map { RealmCharacter(character: $0) }
        
        do {
            try realm.write {
                realm.add(realmCharacters, update: .modified)
            }
        } catch {
            print("Error saving characters: \(error.localizedDescription)")
        }
    }
    
    public func getCharacters() -> [Character] {
        let characters = realm.objects(RealmCharacter.self)
        let characterArray = Array(characters).map { Character(id: $0.id, name: $0.name, status: $0.status, species: $0.species, type: $0.type, gender: $0.gender) }
        
        return characterArray
    }
}
