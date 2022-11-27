import Foundation

struct Settings: Codable {
    let isOnboarded: Bool
}

extension Settings {
    func apply(onboarded toggle: Bool) -> Self {
        .init(isOnboarded: toggle)
    }
}

extension Settings {
    static let defaultValue: Self = .init(isOnboarded: false)
}