public struct Reducer<State: PerduxState, Action: PerduxAction> {
    public let reduce: (State, Action) async -> Void

    #warning("deprecated")
    public init(
            reduce: @escaping (State, Action) async -> Void
    ) {
        self.reduce = reduce
    }
}