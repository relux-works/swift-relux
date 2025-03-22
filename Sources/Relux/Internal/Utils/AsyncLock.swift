/// An async lock implemented using Swift Actor.
///
/// This lock allows you to create critical sections in your asynchronous code.
@usableFromInline
internal actor AsyncLock {
    /// Indicates whether the lock is currently held.
    private var isLocked = false

    /// The queue of tasks waiting to acquire the lock.
    private var waitingTasks: [CheckedContinuation<Void, Never>] = []

    /// Acquires the lock, suspending the current task until the lock becomes available.
    private func lock() async {
        if isLocked {
            await withCheckedContinuation { continuation in
                waitingTasks.append(continuation)
            }
        } else {
            isLocked = true
        }
    }

    /// Releases the lock, allowing other tasks to acquire it.
    private func unlock() {
        if waitingTasks.isEmpty {
            isLocked = false
        } else {
            let continuation = waitingTasks.removeFirst()
            continuation.resume()
        }
    }

    internal init() {}

    /// Executes a given closure while holding the lock.
    ///
    /// This method ensures that the lock is released when the closure completes, even if the closure throws an error.
    ///
    /// - Parameter work: A closure to execute while holding the lock.
    /// - Returns: The result of the closure.
    internal func withLock<T: Sendable>(_ work: () async throws -> T) async rethrows -> T {
        await lock()
        defer { unlock() }
        return try await work()
    }

    internal func withLock<T: Sendable>(_ work: () async -> T) async -> T {
        await lock()
        defer { unlock() }
        return await work()
    }
}
