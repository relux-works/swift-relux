import SwiftUI

struct Splash: View {
    let props: Props
    let actions: Actions

    var body: some View {
        content
                .task(moveNext)
    }

    private var content: some View {
        Color.clear
                .ignoresSafeArea()
                .overlay(message)
    }

    private var message: some View {
        Text("Welcome to PerduxSample")
                .font(.largeTitle).fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
    }
}

// actions
extension Splash {
    private func moveNext() async {
        Task.delayed(byTimeInterval: 2, operation: actions.next)
    }
}