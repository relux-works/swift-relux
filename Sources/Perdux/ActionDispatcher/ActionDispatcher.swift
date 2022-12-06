import Combine
import Foundation
import Logger

public typealias Seconds = Double

public protocol ActionDispatcherSubscriber: AnyObject {
    func notify(_ action: PerduxAction) async
}

extension ActionDispatcher {
    public struct AnyObserver {
        public private(set) weak var observer: ActionDispatcherSubscriber?
    }
}

public final class ActionDispatcher {
    public private(set) static var subscribers: [AnyObserver] = []

    class func connect(_ subscriber: ActionDispatcherSubscriber) {
        subscribers.append(.init(observer: subscriber))
    }


	
	@inlinable @inline(__always)
    public class func emitAsync(
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

	
	@inlinable @inline(__always)
    public class func sequentialPerform(
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

	
	@inlinable @inline(__always)
    public class func concurrentPerform(
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
