import SwiftUI
import CommonCore

struct CharacterRowView: View {
    var character: Character
    
    var body: some View {
        HStack {
            Text(character.name)
                .font(.title)
                .foregroundStyle(Color.primary)
            Spacer()
            Text(CommonLocalizableKey.status_label.localize())
                .font(.title3)
                .foregroundStyle(Color.secondary)
            Text(character.status)
                .font(.title3)
                .foregroundStyle(Color.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    CharacterRowView(character: Character(id: 1, name: "Rick", status: "Alive", species: "some specie", type: "some type", gender: "some gender"))
}
