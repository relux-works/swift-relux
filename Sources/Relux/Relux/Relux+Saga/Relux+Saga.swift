extension Relux {
    public protocol Saga: Actor, TypeKeyable{
        func apply(_ effect: any Relux.Effect) async
    }
}

extension Relux {
    public protocol Flow: Saga {
        typealias Result = ActionResult

        @discardableResult
        func apply(_ effect: any Relux.Effect) async -> Self.Result
    }
}

extension Relux.Saga {
    public func apply(_ effect: any Relux.Effect) async -> Relux.ActionResult {
        await self.apply(effect)
        return .success
    }
}
extension Relux.Flow {
    public func apply(_ effect: any Relux.Effect) async {
        let _: Relux.ActionResult = await self.apply(effect)
    }
}
