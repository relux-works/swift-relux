extension Relux {
    /// Base protocol for action relays.
    /// UI layer adds observation conformance.
    public protocol ActionRelaying: AnyObject, Sendable, TypeKeyable {}
}
