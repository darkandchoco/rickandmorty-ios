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
    @objc dynamic var origin: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var image: String = ""
    
    // Primary key for Realm (optional but recommended for performance)
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Optional initializer if you want to use it in the same way as the struct
    convenience init(id: Int, name: String, status: String, species: String, type: String, gender: String, origin: String, location: String, image: String) {
        self.init()
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
    }
    
    convenience init(character: CommonCore.Character) {
        self.init()
        self.id = character.id
        self.name = character.name
        self.status = character.status
        self.species = character.species
        self.type = character.type
        self.gender = character.gender
        self.origin = character.origin
        self.location = character.location
        self.image = character.image
    }
}
