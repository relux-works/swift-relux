extension Relux {
    public protocol Module: Sendable {
        var states: [any Relux.AnyState] { get }
        var sagas: [any Relux.Saga] { get }
    }
}
