
public protocol TypeKeyable: AnyObject {
    typealias Key = ObjectIdentifier
    nonisolated var key: Key { get }
    nonisolated static var key: Key { get }
}

public extension TypeKeyable {
    nonisolated var key: ObjectIdentifier { .init(type(of: self)) }
    nonisolated static var key: ObjectIdentifier { .init(self) }
}
