import Foundation
import CommonCore
import Combine

protocol CharactersMainViewModelDelegate: AnyObject {
    func charactersMainViewDidTapRow(character: Character)
}

protocol CharactersMainViewModel: ObservableObject {
    var characters: [Character] { get }
    var isLoading: Bool { get set }
    
    func didTapRow(character: Character)
}

final class CharactersMainViewModelImplementation: CharactersMainViewModel {
    private let charactersService: CharactersService
    private var cancellables = Set<AnyCancellable>()
    @Published var characters: [Character] = []
    @Published var isLoading: Bool = false
    
    weak var delegate: CharactersMainViewModelDelegate?
    
    init(charactersService: CharactersService) {
        self.charactersService = charactersService
        self.getCharacters()
    }
    
    internal func getCharacters() {
        isLoading = true
        charactersService.getCharacters()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let failure):
                    self?.isLoading = false
                    print(failure)
                }
            }, receiveValue: { [weak self] characters in
                self?.isLoading = false
                self?.characters = characters
            })
            .store(in: &cancellables)
    }
    
    func didTapRow(character: Character) {
        delegate?.charactersMainViewDidTapRow(character: character)
    }
}

final class CharactersMainViewModelMock: CharactersMainViewModel {
    var characters: [Character] = [
        Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something"),
        Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something"),
        Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something")
    ]
    var isLoading: Bool = false
    
    func didTapRow(character: Character) {
        
    }
}
