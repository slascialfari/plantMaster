import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 48))
                .foregroundStyle(.green)
            Text("Hello, plantMaster!")
                .font(.title)
                .bold()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
