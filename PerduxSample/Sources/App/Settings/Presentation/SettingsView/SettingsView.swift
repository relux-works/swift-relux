import SwiftUIPlus
import SwiftUI

struct SettingsView: View {
    let props: Props
    let actions: Actions

    var body: some View {
        content
    }

    private var content: some View {
        VStack(spacing: 32) {
            NavigationLink(destination: SettingsDetails1()) {
                Text("Details 1")
            }
            AsyncButton(action: actions.openSampleSheet) {
                Text("Open Sample Sheet")
            }
            AsyncButton(action: actions.setNotOnboarded) {
                Text("Set NOT onboarded")
            }
        }
    }
}

struct SettingsDetails1: View {
    @EnvironmentObject private var settingsState: SettingsViewState

    var body: some View {
        VStack {
            Text("onboarded: \(settingsState.settings.isOnboarded.description)")
            NavigationLink(destination: SettingsDetails2()) {
                Text("Details 2")
            }
        }
    }
}

struct SettingsDetails2: View {
    @EnvironmentObject private var settingsState: SettingsViewState

    var body: some View {
        VStack {
            Text("onboarded: \(settingsState.settings.isOnboarded.description)")
            NavigationLink(destination: SettingsDetails3()) {
                Text("Details 3")
            }
        }
    }
}

struct SettingsDetails3: View {
    @EnvironmentObject private var settingsState: SettingsViewState

    var body: some View {
        VStack {
            Text("onboarded: \(settingsState.settings.isOnboarded.description)")
            NavigationLink(destination: SettingsDetails4()) {
                Text("Details 4")
            }
        }
    }
}

struct SettingsDetails4: View {
    @EnvironmentObject private var settingsState: SettingsViewState

    var body: some View {
        VStack {
            Text("onboarded: \(settingsState.settings.isOnboarded.description)")
            AsyncToggle(
                    isOn: .constant(settingsState.settings.isOnboarded),
                    onChange: changeOnboardingState
            ) {
                Text("Change onboarding")
            }
            Text("Max depth")
        }
    }

    private func changeOnboardingState(toggle: Bool) async {
        await action {
            SettingsSideEffect.upsertSettings(newSettings: .defaultValue.apply(onboarded: toggle))
        }
    }
}