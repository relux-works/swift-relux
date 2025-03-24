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
        ) async {
            let execStartTime = timestamp.milliseconds

            if let delay {
                let delay = UInt64(delay * 1_000_000_000)
                try? await Task<Never, Never>.sleep(nanoseconds: delay)
            }
            await actions
                .asyncForEach { action in
                    await subscribers
                        .concurrentForEach {
                            await $0.subscriber?.notify(action)
                        }
                    logger?.logAction(
                        action, startTimeInMillis: execStartTime, privacy: .private, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
                }
        }

        @inline(__always)
        internal static func concurrentPerform(
            _ actions: [Relux.Action],
            delay: Seconds?,
            fileID: String,
            functionName: String,
            lineNumber: Int,
            label: (@Sendable () -> String)? = nil
        ) async {
            let execStartTime = timestamp.milliseconds

            if let delay {
                let delay = UInt64(delay * 1_000_000_000)
                try? await Task<Never, Never>.sleep(nanoseconds: delay)
            }

            await actions
                .concurrentForEach { action in
                    await subscribers
                        .concurrentForEach {
                            await $0.subscriber?.notify(action)
                        }
                    logger?.logAction(
                        action, startTimeInMillis: execStartTime, privacy: .private, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
                }
        }
    }
}
