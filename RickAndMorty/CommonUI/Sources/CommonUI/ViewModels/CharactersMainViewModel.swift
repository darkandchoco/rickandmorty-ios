import Foundation
import CommonCore
import Combine

protocol CharactersMainViewModel: ObservableObject {
    var characters: [Character] { get }
}

final class CharactersMainViewModelImplementation: CharactersMainViewModel {
    private let charactersService: CharactersService
    private var cancellables = Set<AnyCancellable>()
    @Published var characters: [Character] = []
    
    init(charactersService: CharactersService) {
        self.charactersService = charactersService
        self.getCharacters()
    }
    
    private func getCharacters() {
        charactersService.getCharacters()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let failure):
                    print(failure)
                }
            }, receiveValue: { characters in
                self.characters = characters
            })
            .store(in: &cancellables)
    }
}

final class CharactersMainViewModelMock: CharactersMainViewModel {
    var characters: [Character] = [
        Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender"),
        Character(id: 2, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender"),
        Character(id: 3, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender")
    ]
}
