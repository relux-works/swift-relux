public extension Relux.Navigation {
	protocol RouterProtocol: Sendable {
        associatedtype Page: PathComponent
		 
		 func reduce(with action: Relux.Action) async
		 
		 func restore() async
    }
}

internal extension Relux.Navigation.RouterProtocol {
	nonisolated var key: ObjectIdentifier { .init(type(of: self)) }
	nonisolated static var key: ObjectIdentifier { .init(self) }
}
