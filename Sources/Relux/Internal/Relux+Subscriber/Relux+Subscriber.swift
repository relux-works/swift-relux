extension Relux {
    internal protocol Subscriber: AnyObject, Sendable {
        func perform(_ action: Relux.Action) async -> ActionResult
    }
}

extension Relux {
    internal struct SubscriberRef: Sendable {
        private(set) weak var subscriber: (any Relux.Subscriber)?

        init(subscriber: (any Relux.Subscriber)?) {
            self.subscriber = subscriber
        }
    }
}
