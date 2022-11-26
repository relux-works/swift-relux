import SwiftUI

struct SettingsView: View {
    let props: Props
    let actions: Actions

    var body: some View {
        content
    }

    private var content: some View {
        AsyncButton(action: actions.openSampleSheet) {
            Text("OPEN SAMPLE SHEET")
        }
    }
}