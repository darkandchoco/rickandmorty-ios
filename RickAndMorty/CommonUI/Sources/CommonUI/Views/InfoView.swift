import SwiftUI

struct InfoView: View {
    var message: String
    var isError: Bool

    var body: some View {
        VStack {
            Text(message)
                .font(.body)
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(isError ? Color.red : Color.blue)
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    InfoView(message: "Sample message", isError: false)
}

#Preview {
    InfoView(message: "Sample message", isError: true)
}
