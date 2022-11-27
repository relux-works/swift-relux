import SwiftUI

struct OnboardingView: View {
    let props: Props
    let actions: Actions

    var body: some View {
        content
    }

    private var content: some View {
        VStack {
            Spacer()
            Text("Perdux sample onboarding")
            Spacer()
            AsyncButton(action: actions.completeOnboarding) {
                Text("Continue")
            }.padding(.bottom, 32)
        }
    }
}
