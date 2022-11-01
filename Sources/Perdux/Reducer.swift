public struct Reducer<State: PerduxState, Action: PerduxAction> {
    public let reduce: (State, Action) async -> Void

    public init(
            reduce: @escaping (State, Action) async -> Void
    ) {
        self.reduce = reduce
    }
}