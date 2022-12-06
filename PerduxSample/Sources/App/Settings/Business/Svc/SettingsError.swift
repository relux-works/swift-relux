import Foundation

enum SettingsError: Error {
    case failedToGetSettings(cause: Error)
    case failedToUpsertSettings(cause: Error)
}