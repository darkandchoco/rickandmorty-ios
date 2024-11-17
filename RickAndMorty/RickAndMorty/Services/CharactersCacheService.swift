import Foundation
import CommonCore
import RealmSwift

public final class CharactersCacheServiceImplementation: CharactersCacheService {
    private let realm = try! Realm()
    
    public init() {
        
    }
    
    public func saveCharacters(_ characters: [CommonCore.Character]) {
        let realmCharacters = characters.map { RealmCharacter(character: $0) }
        
        do {
            try realm.write {
                realm.add(realmCharacters, update: .modified)
            }
        } catch {
            print("Error saving characters: \(error.localizedDescription)")
        }
    }
    
    public func getCharacters() -> [CommonCore.Character] {
        let characters = realm.objects(RealmCharacter.self)
        let characterArray = Array(characters).map { CommonCore.Character(id: $0.id, name: $0.name, status: $0.status, species: $0.species, type: $0.type, gender: $0.gender, origin: $0.origin, location: $0.location, image: $0.image) }
        
        return characterArray
    }
}
