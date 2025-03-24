extension Relux {
    internal protocol Subscriber: AnyObject, Sendable {
        func notify(_ action: Relux.Action) async
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
