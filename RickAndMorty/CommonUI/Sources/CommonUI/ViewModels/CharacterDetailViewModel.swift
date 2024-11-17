import Foundation
import CommonCore

protocol CharacterDetailViewModel: ObservableObject {
    var character: Character { get }
    var isLoading: Bool { get set }
}

final class CharacterDetailViewModelImplementation: CharacterDetailViewModel {
    @Published var isLoading: Bool = false
    @Published var character: Character
    
    init(character: Character) {
        self.character = character
    }
}

final class CharacterDetailViewModelMock: CharacterDetailViewModel {
    var isLoading: Bool = false
    var character: Character = Character(
        id: 1,
        name: "Rick Sanchez",
        status: "Alive",
        species: "Human",
        type: "",
        gender: "Male",
        origin: "Earth (C-137)",
        location: "Earth (Replacement Dimension)",
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
    )
}
