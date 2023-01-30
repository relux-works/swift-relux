import Foundation

extension ActionDispatcher {
	public enum ExecutionType: Sendable {
        case serially
        case concurrently
    }
}
