import Foundation

// John Sundell (c)
// https://github.com/JohnSundell/CollectionConcurrencyKit/blob/main/Sources/CollectionConcurrencyKit.swift

extension Sequence where Element: Sendable {

    @inlinable @inline(__always)
    func asyncForEach(
        _ operation: @escaping @Sendable (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }

    @inlinable @inline(__always)
    func concurrentForEach(
        withPriority priority: TaskPriority? = nil,
        _ operation: @escaping @Sendable (Element) async -> Void
    ) async {
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask(priority: priority) {
                    await operation(element)
                }
            }
        }
    }
}

extension Sequence where Element: Sendable {
    @inline(__always)
    func asyncMap<T>(
        _ transform: @escaping @Sendable (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }

    @inline(__always)
    func concurrentMap<T: Sendable>(
        withPriority priority: TaskPriority? = nil,
        _ transform: @escaping @Sendable (Element) async -> T
    ) async -> [T] {
        let tasks = map { element in
            Task(priority: priority) {
                await transform(element)
            }
        }

        return await tasks.asyncMap { task in
            await task.value
        }
    }

    @inline(__always)
    func concurrentMap<T: Sendable>(
        withPriority priority: TaskPriority? = nil,
        _ transform: @escaping @Sendable (Element) async throws -> T
    ) async rethrows -> [T] {
        let tasks = map { element in
            Task(priority: priority) {
                try await transform(element)
            }
        }

        return try await tasks.asyncMap { task in
            try await task.value
        }
    }
}

extension Sequence where Element: Sendable {
    @inline(__always)
    func asyncCompactMap<T: Sendable>(
        _ transform: @escaping @Sendable (Element) async throws -> T?
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            guard let value = try await transform(element) else {
                continue
            }

            values.append(value)
        }

        return values
    }

    @inline(__always)
    func concurrentCompactMap<T: Sendable>(
        withPriority priority: TaskPriority? = nil,
        _ transform: @escaping @Sendable (Element) async -> T?
    ) async -> [T] {
        let tasks = map { element in
            Task(priority: priority) {
                await transform(element)
            }
        }

        return await tasks.asyncCompactMap { task in
            await task.value
        }
    }

    @inline(__always)
    func concurrentCompactMap<T: Sendable>(
        withPriority priority: TaskPriority? = nil,
        _ transform: @escaping @Sendable (Element) async throws -> T?
    ) async rethrows -> [T] {
        let tasks = map { element in
            Task(priority: priority) {
                try await transform(element)
            }
        }

        return try await tasks.asyncCompactMap { task in
            try await task.value
        }
    }
}

extension Sequence where Element: Sendable {
    @inline(__always)
    func asyncFlatMap<T: Sequence>(
        _ transform: @escaping @Sendable (Element) async throws -> T
    ) async rethrows -> [T.Element] {
        var values = [T.Element]()

        for element in self {
            try await values.append(contentsOf: transform(element))
        }

        return values
    }

    @inline(__always)
    func concurrentFlatMap<T: Sequence & Sendable>(
        withPriority priority: TaskPriority? = nil,
        _ transform: @escaping @Sendable (Element) async -> T
    ) async -> [T.Element] {
        let tasks = map { element in
            Task(priority: priority) {
                await transform(element)
            }
        }

        return await tasks.asyncFlatMap { task in
            await task.value
        }
    }

    @inline(__always)
    func concurrentFlatMap<T: Sequence & Sendable>(
        withPriority priority: TaskPriority? = nil,
        _ transform: @escaping @Sendable (Element) async throws -> T
    ) async rethrows -> [T.Element] {
        let tasks = map { element in
            Task(priority: priority) {
                try await transform(element)
            }
        }

        return try await tasks.asyncFlatMap { task in
            try await task.value
        }
    }
}
