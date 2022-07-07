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

    public class func emitSync(_ action: PerduxAction) {
        log(action)
        action.executionQueue.sync {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync(_ action: PerduxAction) {
        log(action)
        action.executionQueue.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync(_ action: PerduxAction, queue: DispatchQueue) {
        log(action)
        queue.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsyncMain(_ action: PerduxAction, delay: Double) {
        log(action)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }
    public class func emitAsyncMain(_ action: PerduxAction) {
        log(action)
        DispatchQueue.main.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync(_ action: PerduxAction, delay: Double) {
        log(action)
        action.executionQueue.asyncAfter(deadline: .now() + delay) {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync(_ actions: [PerduxAction]) {
        actions.forEach { log($0) }

        subscribers.forEach { subscriber in
            actions.forEach { action in
                action.executionQueue.async {
                    subscriber.notify(action)
                }
            }
        }
    }
}
