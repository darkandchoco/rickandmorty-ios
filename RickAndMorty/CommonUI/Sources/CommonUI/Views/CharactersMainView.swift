import SwiftUI

struct CharactersMainView<ViewModel>: View where ViewModel: CharactersMainViewModel {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.characters) { character in
                CharacterRowView(character: character)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    CharactersMainView(viewModel: CharactersMainViewModelMock())
}

protocol CharactersMainViewModel: ObservableObject {
    var characters: [Character] { get }
}

final class CharactersMainViewModelMock: CharactersMainViewModel {
    var characters: [Character] = [
        Character(id: "1", name: "Rick", status: "Alive"),
        Character(id: "1", name: "Rick", status: "Alive"),
        Character(id: "1", name: "Rick", status: "Alive")
    ]
}
