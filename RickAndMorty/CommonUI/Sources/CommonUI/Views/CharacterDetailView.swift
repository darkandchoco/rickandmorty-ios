import SwiftUI
import CommonCore

struct CharacterDetailView<ViewModel>: View where ViewModel: CharacterDetailViewModel {
    @ObservedObject var viewModel: ViewModel
    
    var characterImage: some View {
        if let url = URL(string: viewModel.character.image) {
            AnyView(AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 150, height: 150)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 4)
                        )
                        .shadow(radius: 10)
                        .frame(width: 150, height: 150)
                case .failure:
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.red)
                @unknown default:
                    EmptyView()
                }
            })
        } else {
            AnyView(Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.gray))
        }
    }
    
    private func propertyView(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                characterImage
                    .padding(.top, 20)
                
                Text(viewModel.character.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
                
                VStack(spacing: 10) {
                    propertyView(label: CommonLocalizableKey.status_label.localize(), value: viewModel.character.status)
                    propertyView(label: CommonLocalizableKey.species_label.localize(), value: viewModel.character.species)
                    propertyView(label: CommonLocalizableKey.type_label.localize(), value: viewModel.character.type)
                    propertyView(label: CommonLocalizableKey.gender_label.localize(), value: viewModel.character.gender)
                    propertyView(label: CommonLocalizableKey.origin_label.localize(), value: viewModel.character.origin)
                    propertyView(label: CommonLocalizableKey.location_label.localize(), value: viewModel.character.location)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                Spacer()
            }
            .loading(isLoading: $viewModel.isLoading)
        }
    }
}

#Preview {
    CharacterDetailView(viewModel: CharacterDetailViewModelMock())
}
