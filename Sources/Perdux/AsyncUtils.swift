import Foundation
// John Sundell (c)
// https://github.com/JohnSundell/CollectionConcurrencyKit/blob/main/Sources/CollectionConcurrencyKit.swift

internal extension Sequence {
    func asyncForEach(
            _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }

    func concurrentForEach(
            withPriority priority: TaskPriority? = nil,
            _ operation: @escaping (Element) async -> Void
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

internal extension Sequence {
    func asyncMap<T>(
            _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }

    func concurrentMap<T>(
            withPriority priority: TaskPriority? = nil,
            _ transform: @escaping (Element) async -> T
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

    func concurrentMap<T>(
            withPriority priority: TaskPriority? = nil,
            _ transform: @escaping (Element) async throws -> T
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

internal extension Sequence {
    func asyncCompactMap<T>(
            _ transform: (Element) async throws -> T?
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

    func concurrentCompactMap<T>(
            withPriority priority: TaskPriority? = nil,
            _ transform: @escaping (Element) async -> T?
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

    func concurrentCompactMap<T>(
            withPriority priority: TaskPriority? = nil,
            _ transform: @escaping (Element) async throws -> T?
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

internal extension Sequence {
    func asyncFlatMap<T: Sequence>(
            _ transform: (Element) async throws -> T
    ) async rethrows -> [T.Element] {
        var values = [T.Element]()

        for element in self {
            try await values.append(contentsOf: transform(element))
        }

        return values
    }

    func concurrentFlatMap<T: Sequence>(
            withPriority priority: TaskPriority? = nil,
            _ transform: @escaping (Element) async -> T
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

    func concurrentFlatMap<T: Sequence>(
            withPriority priority: TaskPriority? = nil,
            _ transform: @escaping (Element) async throws -> T
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

