
extension Relux.Testing.MockModule {
    public actor Saga: Relux.Saga {
        public init() {}

        public var effects: [Relux.Effect] = []

        public func apply(_ effect: any Relux.Effect) async {
            effects.append(effect)
        }
    }
}
