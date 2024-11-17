import SwiftUI
import CommonCore

struct CharacterDetailView<ViewModel>: View where ViewModel: CharacterDetailViewModel {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Text("Hello")
        .loading(isLoading: $viewModel.isLoading)
    }
}

#Preview {
    CharacterDetailView(viewModel: CharacterDetailViewModelMock())
}

protocol CharacterDetailViewModel: ObservableObject {
    var character: Character { get }
    var isLoading: Bool { get set }
}

final class CharacterDetailViewModelMock: CharacterDetailViewModel {
    var isLoading: Bool = false
    var character: Character = Character(id: 1, name: "Richmond", status: "Rich", species: "Human", type: "something", gender: "Male")
}


