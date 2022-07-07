import Foundation
import Logger

public protocol PerduxAction: EnumReflectable {
    var executionQueue: DispatchQueue { get }
    var qos: DispatchQoS { get }
}

public extension PerduxAction {
    var executionQueue: DispatchQueue {
        DispatchQueue(label: "\(Self.Type.self)", qos: qos)
    }
    var qos: DispatchQoS { .default }
}