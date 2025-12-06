extension Relux {
    /// Protocol for objects that relay state snapshots to the UI layer.
    ///
    /// A StateRelaying instance subscribes to a state's snapshot stream and
    /// provides the current value for UI observation. The concrete implementation
    /// in swiftui-relux (`Relux.UI.StateRelay`) conforms to `ObservableObject`
    /// for SwiftUI integration.
    ///
    /// This protocol is defined in darwin-relux (pure Swift) to allow the Store
    /// to hold relays without depending on UI frameworks.
    ///
    /// Example:
    /// ```swift
    /// // swiftui-relux provides the concrete implementation
    /// let relay = Relux.UI.StateRelay(orientationState)
    ///
    /// // Store holds type-erased relays
    /// store.connect(relay: relay)
    /// ```
    public protocol StateRelaying: AnyObject, Sendable {
        /// The snapshot type this relay provides.
        associatedtype Snapshot: StateSnapshot

        /// The current snapshot value.
        @MainActor var value: Snapshot { get }

        /// Key for dictionary storage, based on Snapshot type.
        var snapshotTypeKey: TypeKeyable.Key { get }
    }
}

extension Relux.StateRelaying {
    public var snapshotTypeKey: TypeKeyable.Key {
        ObjectIdentifier(Snapshot.self)
    }
}
