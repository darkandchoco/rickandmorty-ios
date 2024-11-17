import SwiftUI
import CommonCore
struct CharactersMainView<ViewModel>: View where ViewModel: CharactersMainViewModel {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                InfoView(message: errorMessage, isError: true)
            }
            
            // Search Bar
            TextField("Search characters", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            List {
                ForEach(viewModel.filteredCharacters) { character in
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
