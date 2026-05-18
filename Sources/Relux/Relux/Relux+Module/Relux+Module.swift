extension Relux {
    public typealias ModuleKey = ObjectIdentifier

    public protocol Module: Sendable {
        nonisolated var moduleKey: Relux.ModuleKey { get }
        var dependencies: [any Relux.Module] { get }
        var states: [any Relux.AnyState] { get }
        var sagas: [any Relux.Saga] { get }
    }
}

public extension Relux.Module {
    nonisolated var moduleKey: Relux.ModuleKey {
        ObjectIdentifier(type(of: self))
    }

    var dependencies: [any Relux.Module] {
        []
    }
}
