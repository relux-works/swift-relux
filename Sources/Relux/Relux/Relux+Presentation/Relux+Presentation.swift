public extension Relux { enum Presentation {} }

public extension Relux.Presentation {
	@MainActor
	protocol StatePresenting: AnyObject, Sendable {}
}

internal extension Relux.Presentation.StatePresenting {
	var key: ObjectIdentifier { .init(type(of: self)) }
	static var key: ObjectIdentifier { .init(self) }
}
