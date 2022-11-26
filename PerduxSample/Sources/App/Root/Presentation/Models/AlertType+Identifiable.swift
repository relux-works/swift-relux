import Foundation

extension ModalPage: Identifiable {
    var id: String {
        switch self {
        case .sampleSheet: return "sampleSheet"
        }
    }
}