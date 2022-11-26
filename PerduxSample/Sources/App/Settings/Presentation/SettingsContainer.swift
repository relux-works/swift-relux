import SwiftUI

struct SettingsContainer: View {
    var body: some View {
        content
    }

    private var content: some View {
        SettingsView(
                props: .init(),
                actions: .init(
                        openSampleSheet: openSampleSheet
                )
        )
    }

    private func openSampleSheet() async {
        await NavigationAction.setModalSheet(new: .sampleSheet).perform()
    }
}