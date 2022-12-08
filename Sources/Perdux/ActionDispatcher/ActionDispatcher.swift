import Combine
import Foundation
import Logger

public typealias Seconds = Double

public protocol ActionDispatcherSubscriber: AnyObject {
    func notify(_ action: PerduxAction) async
}

public final class ActionDispatcher {
    public private(set) static var subscribers: [AnyObserver] = []

    class func connect(_ subscriber: ActionDispatcherSubscriber) {
        subscribers.append(.init(observer: subscriber))
    }

    @usableFromInline @inline(__always)
    internal class func emitAsync(
            _ action: PerduxAction,
            delay: Seconds? = nil,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {

        if let delay {
            let delay = UInt64(delay * 1_000_000_000)
            try? await Task<Never, Never>.sleep(nanoseconds: delay)
        }

        log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
        await subscribers
                .concurrentForEach { await $0.observer?.notify(action) }
    }

	
    @usableFromInline @inline(__always)
    internal class func sequentialPerform(
            _ actions: [PerduxAction],
            delay: Seconds? = nil,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {

        if let delay {
            let delay = UInt64(delay * 1_000_000_000)
            try? await Task<Never, Never>.sleep(nanoseconds: delay)
        }

        await actions
                .asyncForEach { action in
                    log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
                    await subscribers
                            .concurrentForEach { await $0.observer?.notify(action) }
                }
    }

	
    @usableFromInline @inline(__always)
    internal class func concurrentPerform(
            _ actions: [PerduxAction],
            delay: Seconds? = nil,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) async {

        if let delay {
            let delay = UInt64(delay * 1_000_000_000)
            try? await Task<Never, Never>.sleep(nanoseconds: delay)
        }

        await actions
                .concurrentForEach { action in
                log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
                await subscribers
                        .concurrentForEach { await $0.observer?.notify(action) }
        }
    }
}
