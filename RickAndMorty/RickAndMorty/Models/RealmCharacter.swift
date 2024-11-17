import Foundation
import RealmSwift
import CommonCore

// Define the Realm Object (data model)
class RealmCharacter: Object, Identifiable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var status: String = ""
    @objc dynamic var species: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var gender: String = ""
    
    // Primary key for Realm (optional but recommended for performance)
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Optional initializer if you want to use it in the same way as the struct
    convenience init(id: Int, name: String, status: String, species: String, type: String, gender: String) {
        self.init()
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
    }
    
    convenience init(character: CommonCore.Character) {
        self.init()
        self.id = character.id
        self.name = character.name
        self.status = character.status
        self.species = character.species
        self.type = character.type
        self.gender = character.gender
    }
}
