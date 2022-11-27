import SwiftUI

struct SettingsView: View {
    let props: Props
    let actions: Actions

    var body: some View {
        content
    }

    private var content: some View {
        VStack(spacing: 32) {
            AsyncButton(action: actions.openSampleSheet) {
                Text("Open Sample Sheet")
            }
            AsyncButton(action: actions.setNotOnboarded) {
                Text("Set NOT onboarded")
            }
        }
    }
}