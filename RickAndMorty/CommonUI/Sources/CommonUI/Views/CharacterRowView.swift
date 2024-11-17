import SwiftUI
import CommonCore

struct CharacterRowView: View {
    var character: Character
    var didTapRow: (_ character: Character) -> Void
    
    var body: some View {
        HStack {
            Text(character.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(CommonLocalizableKey.status_label.localize())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(character.status)
                    .font(.body)
                    .foregroundColor(character.status == "Alive" ? .green : .red)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(12)
        .onTapGesture {
            didTapRow(character)
        }
    }
}

#Preview {
    CharacterRowView(character: Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender", origin: "Earth", location: "Earth", image: "something"), didTapRow: { _ in
        
    })
}
