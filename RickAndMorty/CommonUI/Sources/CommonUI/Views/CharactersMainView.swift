import SwiftUI
import CommonCore

struct CharactersMainView<ViewModel>: View where ViewModel: CharactersMainViewModel {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                InfoView(message: errorMessage, isError: true)
            }
            List {
                ForEach(viewModel.characters) { character in
                    CharacterRowView(character: character, didTapRow: { character in
                        viewModel.didTapRow(character: character)
                    })
                }
            }
            .listStyle(.plain)
            .refreshable {
                viewModel.refreshData()
            }
        }
        .loading(isLoading: $viewModel.isLoading)
    }
}

#Preview {
    CharactersMainView(viewModel: CharactersMainViewModelMock())
}
