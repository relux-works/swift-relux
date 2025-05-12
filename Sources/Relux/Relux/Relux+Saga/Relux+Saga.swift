extension Relux {
    public protocol Saga: Actor, TypeKeyable{
        func apply(_ effect: any Relux.Effect) async
    }
}

extension Relux.Saga {
    public func apply(_ effect: any Relux.Effect) async -> Relux.ActionResult {
        await self.apply(effect)
        return .success
    }
}
