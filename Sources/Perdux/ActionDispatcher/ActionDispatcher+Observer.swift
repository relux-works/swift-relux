import Foundation

extension ActionDispatcher {
    public struct AnyObserver {
        public private(set) weak var observer: ActionDispatcherSubscriber?
    }
}