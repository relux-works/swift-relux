public extension Relux {
	protocol State: Actor, AnyObject {
		func reduce(with action: any Relux.Action) async
		
		func cleanup() async
	}
}

internal extension Relux.State {
	nonisolated var key: ObjectIdentifier { .init(type(of: self)) }
	nonisolated static var key: ObjectIdentifier { .init(self) }
}
