extension Relux {
    /// Protocol for snapshot value types that can be observed by the UI layer.
    ///
    /// Snapshots are immutable, value-type projections of state designed for
    /// UI observation. They capture the relevant state properties at a point
    /// in time without exposing state machine internals.
    ///
    /// Example:
    /// ```swift
    /// struct OrientationSnapshot: Relux.StateSnapshot {
    ///     let orientation: DeviceOrientation
    ///     let isMonitoring: Bool
    /// }
    /// ```
    public protocol StateSnapshot: Equatable, Sendable {}
}

/// Protocol for states that produce typed snapshots for observation.
///
/// This enables UI layers to observe state changes through a value-type snapshot
/// without depending on the concrete state implementation.
///
/// Conforming types provide:
/// - A current snapshot value
/// - An async stream of snapshot updates
///
/// Note: This protocol is MainActor-isolated since it's primarily used for
/// UI observation where state access happens on the main thread.
@MainActor
public protocol SnapshotProviding: Sendable {
    /// The snapshot type that represents observable state.
    associatedtype Snapshot: Relux.StateSnapshot

    /// The current snapshot value.
    var current: Snapshot { get }

    /// An async stream that emits snapshots when state changes.
    /// Implementations should emit deduplicated values (no consecutive duplicates).
    var snapshots: AsyncStream<Snapshot> { get }
}
