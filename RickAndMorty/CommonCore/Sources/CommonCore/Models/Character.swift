import Foundation

public struct Character: Identifiable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let gender: String
    
    public init(id: Int, name: String, status: String, species: String, type: String, gender: String) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
    }
}
