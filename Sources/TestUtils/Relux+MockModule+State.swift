import Foundation

extension Relux.Testing.MockModule {
    public actor State: Relux.BusinessState {
        public var actions: [Relux.Action] = []
        public var cleanupCalledAt: Date?

        public init() {}

        public func reduce(with action: any Relux.Action) async {
            self.actions.append(action)
        }

        public func cleanup() async {
            self.cleanupCalledAt = Date()
        }
    }
}
