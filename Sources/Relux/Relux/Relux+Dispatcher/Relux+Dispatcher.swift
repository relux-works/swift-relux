extension Relux {
    actor Dispatcher {
        internal private(set) static var subscribers: [Relux.SubscriberRef] = []
        internal private(set) static var logger: (any Relux.Logger)?

        internal static func subscribe(_ subscriber: Relux.Subscriber) {
            subscribers.append(.init(subscriber: subscriber))
        }

        internal static func setup(logger: (any Relux.Logger)) {
            self.logger = logger
        }

        @inline(__always)
        internal static func sequentialPerform(
            _ actions: [Relux.Action],
            delay: Seconds?,
            fileID: String,
            functionName: String,
            lineNumber: Int,
            label: (@Sendable () -> String)? = nil
        ) async -> Relux.ActionResult {
            let execStartTime = timestamp.milliseconds

            if let delay {
                let delay = UInt64(delay * 1_000_000_000)
                try? await Task<Never, Never>.sleep(nanoseconds: delay)
            }

            return await actions
                .asyncFlatMap { action in
                    let results = await subscribers
                        .lazy
                        .compactMap { $0.subscriber }
                        .concurrentCompactMap { await $0.perform(action) }

                    logger?.logAction(
                        action, result: results.reducedResult, startTimeInMillis: execStartTime, privacy: .private, fileID: fileID, functionName: functionName, lineNumber: lineNumber)

                    return results
                }
                .reducedResult
        }

        @inline(__always)
        internal static func concurrentPerform(
            _ actions: [Relux.Action],
            delay: Seconds?,
            fileID: String,
            functionName: String,
            lineNumber: Int,
            label: (@Sendable () -> String)? = nil
        ) async -> Relux.ActionResult {
            let execStartTime = timestamp.milliseconds

            if let delay {
                let delay = UInt64(delay * 1_000_000_000)
                try? await Task<Never, Never>.sleep(nanoseconds: delay)
            }

            return await actions
                .concurrentFlatMap { action in
                    let results = await subscribers
                        .lazy
                        .compactMap { $0.subscriber }
                        .concurrentCompactMap {
                            await $0.perform(action)
                        }

                    logger?.logAction(
                        action, result: results.reducedResult, startTimeInMillis: execStartTime, privacy: .private, fileID: fileID, functionName: functionName, lineNumber: lineNumber)

                    return results
                }
                .reducedResult
        }
    }
}
