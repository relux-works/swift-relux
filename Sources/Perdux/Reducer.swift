public struct Reducer<State: PerduxState, Action: PerduxAction> {
    public let reduce: (State, Action) -> Void

    public init(
            reduce: @escaping (State, Action) -> Void
    ) {
        self.reduce = reduce
    }
}