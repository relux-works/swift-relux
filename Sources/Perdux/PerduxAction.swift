import Foundation
import Logger

public protocol PerduxAction: EnumReflectable {
    static var executionQueue: DispatchQueue { get }
}
