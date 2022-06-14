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

    public class func emitSync<Action: PerduxAction>(_ action: Action) {
        log(action)
        Action.executionQueue.sync {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync<Action: PerduxAction>(_ action: Action){
        log(action)
        Action.executionQueue.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync<Action: PerduxAction>(_ action: Action, queue: DispatchQueue) {
        log(action)
        queue.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsyncMain<Action: PerduxAction>(_ action: Action) {
        log(action)
        DispatchQueue.main.async {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync<Action: PerduxAction>(_ action: Action, delay: Double) {
        log(action)
        Action.executionQueue.asyncAfter(deadline: .now() + delay) {
            subscribers.forEach {
                $0.notify(action)
            }
        }
    }

    public class func emitAsync<Action: PerduxAction>(_ actions: [Action]) {
        Action.executionQueue.async {

            actions.forEach { action in
                log(action)
            }

            subscribers.forEach { subscriber in
                actions.forEach { action in
                    subscriber.notify(action)
                }
            }
        }
    }
}
