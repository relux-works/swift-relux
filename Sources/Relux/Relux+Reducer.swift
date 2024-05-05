extension Relux {
    public struct Reducer<State: ReluxState, Action: ReluxAction> {
        public let reduce: (State, Action) async -> Void

        public init(
            reduce: @escaping (State, Action) async -> Void
        ) {
            self.reduce = reduce
        }
    }
}
