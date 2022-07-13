import Combine
import Foundation
import Logger

protocol ActionDispatcherSubscriber {
    func notify(_ action: PerduxAction)
}

public typealias AD = ActionDispatcher

public class ActionDispatcher {
    private static var subscribers: [ActionDispatcherSubscriber] = []

    class func subscribe(_ subscriber: ActionDispatcherSubscriber) {
        subscribers.append(subscriber)
    }

    public class func emitSync(
            _ action: PerduxAction,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) {
        log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
        action.executionQueue.sync {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync(
            _ action: PerduxAction,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) {
        log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
        action.executionQueue.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync(
            _ action: PerduxAction,
            queue: DispatchQueue,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) {
        log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
        queue.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsyncMain(
            _ action: PerduxAction,
            delay: Double,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) {
        log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }
    public class func emitAsyncMain(
            _ action: PerduxAction,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) {
        log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
        DispatchQueue.main.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync(
            _ action: PerduxAction,
            delay: Double,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) {
        log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
        action.executionQueue.asyncAfter(deadline: .now() + delay) {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync(
            _ actions: [PerduxAction],
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) {
        actions.forEach { action in
            action.executionQueue.async {
                log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
                subscribers.forEach { subscriber in
                    subscriber.notify(action)
                }
            }
        }
    }

    public class func emitSync(
            _ actions: [PerduxAction],
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) {
        actions.forEach { action in
            action.executionQueue.sync {
                log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
                subscribers.forEach { subscriber in
                    subscriber.notify(action)
                }
            }
        }
    }

    public class func emitAsync(
            _ actions: [PerduxAction],
            delay: Double,
            fileID: String = #fileID,
            functionName: String = #function,
            lineNumber: Int = #line
    ) {
        actions.forEach { action in
            action.executionQueue.asyncAfter(deadline: .now() + delay) {
                log(action, fileID: fileID, functionName: functionName, lineNumber: lineNumber)
                subscribers.forEach { subscriber in
                    subscriber.notify(action)
                }
            }
        }
    }
}
