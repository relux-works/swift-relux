extension Relux {
    public actor Dispatcher {
        private var subscribers: [Relux.SubscriberRef] = []
        private var logger: any Relux.Logger

        internal init(
            subscribers: [Relux.Subscriber],
            logger: any Relux.Logger
        ) {
            self.subscribers = subscribers.map {.init(subscriber: $0) }
            self.logger = logger
        }

        public init(
            logger: any Relux.Logger
        ) {
            self.init(subscribers: [], logger: logger)
        }

        @inline(__always)
        internal func sequentialPerform(
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
                    let results = await self.subscribers
                        .lazy
                        .compactMap { $0.subscriber }
                        .concurrentCompactMap { await $0.perform(action) }

                    await self.logger.logAction(
                        action, result: results.reducedResult, startTimeInMillis: execStartTime, privacy: .private, fileID: fileID, functionName: functionName, lineNumber: lineNumber)

                    return results
                }
                .reducedResult
        }


        @inline(__always)
        internal func concurrentPerform(
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
                    let results = await self.subscribers
                        .lazy
                        .compactMap { $0.subscriber }
                        .concurrentCompactMap {
                            await $0.perform(action)
                        }

                    await self.logger.logAction(
                        action, result: results.reducedResult, startTimeInMillis: execStartTime, privacy: .private, fileID: fileID, functionName: functionName, lineNumber: lineNumber)

                    return results
                }
                .reducedResult
        }
    }
}
