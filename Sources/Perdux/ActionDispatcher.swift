import Combine
import Foundation
import Logger

protocol ActionDispatcherSubscriber {
    func notify(_ action: PerduxAction) async
}

extension Collection where Element == PerduxAction {
    public func sequentialPerform(
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {
        await ActionDispatcher.sequentialPerform(self.map { $0 }, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
    }

    public func concurrentPerform(
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {
        await ActionDispatcher.concurrentPerform(self.map { $0 }, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
    }

    public func concurrentPerform(
            delay: Double,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {
        await ActionDispatcher.concurrentPerform(self.map { $0 }, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
    }
}

extension PerduxAction {
    public func perform(
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {
        await ActionDispatcher.emitAsync(self, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
    }

    public func delayedPerform(
            delay: Double,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {
        await ActionDispatcher.emitAsync(self, delay: delay, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
    }
}

public class ActionDispatcher {
    private static var subscribers: [ActionDispatcherSubscriber] = []

    class func connect(_ subscriber: ActionDispatcherSubscriber) {
        subscribers.append(subscriber)
    }

    public class func emitAsync(
            _ action: PerduxAction,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {
        log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
        await subscribers
                .concurrentForEach { await $0.notify(action) }
    }

    public class func emitAsync(
            _ action: PerduxAction,
            delay: Double,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {
        let delay = UInt64(delay * 1_000_000_000)
        try? await Task<Never, Never>.sleep(nanoseconds: delay)
        log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
        await subscribers
                .concurrentForEach { await $0.notify(action) }
    }

    public class func sequentialPerform(
            _ actions: [PerduxAction],
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {
        await actions
                .asyncForEach { action in
                    log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
                    await subscribers
                            .concurrentForEach { subscriber in await subscriber.notify(action) }
                }
    }


    public class func concurrentPerform(
            _ actions: [PerduxAction],
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {
        await actions
                .concurrentForEach { action in
                log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
                await subscribers
                        .concurrentForEach { subscriber in await subscriber.notify(action)
                }
        }
    }

    public class func concurrentPerform(
            _ actions: [PerduxAction],
            delay: Double,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {
        let delay = UInt64(delay * 1_000_000_000)
        try? await Task<Never, Never>.sleep(nanoseconds: delay)
        await actions
                .concurrentForEach { action in
                log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
                await subscribers
                        .concurrentForEach { subscriber in await subscriber.notify(action) }
        }
    }
}