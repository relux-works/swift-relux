extension Relux {
    public protocol Module: Sendable {
        var states: [any Relux.AnyState] { get }
        var sagas: [any Relux.Saga] { get }
        var relays: [any Relux.StateRelaying] { get }
        var actionRelays: [any Relux.ActionRelaying] { get }
    }
}

// Default implementation for modules without relays
extension Relux.Module {
    public var relays: [any Relux.StateRelaying] { [] }
    public var actionRelays: [any Relux.ActionRelaying] { [] }
}
