import Foundation
import CommonCore
import Combine

protocol CharactersMainViewModelDelegate: AnyObject {
    func charactersMainViewDidTapRow(character: Character)
}
protocol CharactersMainViewModel: ObservableObject {
    var characters: [Character] { get }
    var filteredCharacters: [Character] { get }
    var errorMessage: String? { get }
    var isLoading: Bool { get set }
    var searchText: String { get set }
    
    func didTapRow(character: Character)
    func refreshData()
}

final class CharactersMainViewModelImplementation: CharactersMainViewModel {
    private let charactersService: CharactersService
    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""
    @Published var characters: [Character] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var filteredCharacters: [Character] {
        if searchText.isEmpty {
            return characters
        } else {
            return characters.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
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
                    self?.errorMessage = failure.localizedDescription
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
    
    func refreshData() {
        self.errorMessage = nil
        getCharacters()
    }
}

final class CharactersMainViewModelMock: CharactersMainViewModel {
    var searchText: String = ""
    
    var filteredCharacters: [Character] = [
        Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something"),
        Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something"),
        Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something")
    ]
    var characters: [Character] = [
        Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something"),
        Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something"),
        Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something")
    ]
    var isLoading: Bool = false
    var errorMessage: String? = "Test error"
    
    func didTapRow(character: Character) {
        
    }
    
    func refreshData() {
        
    }
}
