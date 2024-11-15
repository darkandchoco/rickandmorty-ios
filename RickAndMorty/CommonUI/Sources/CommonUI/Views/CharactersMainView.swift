import SwiftUI
import CommonCore

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
