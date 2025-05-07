extension Relux {
    public protocol Saga: Actor, TypeKeyable{
        func apply(_ effect: any Relux.Effect) async
    }
}

extension Relux {
    public protocol Flow: Saga {
        @discardableResult
        func apply(_ effect: any Relux.Effect) async -> Relux.FlowResult
    }
}

extension Relux.Saga {
    public func apply(_ effect: any Relux.Effect) async -> Relux.FlowResult {
        await self.apply(effect)
        return .success
    }
}
extension Relux.Flow {
    public func apply(_ effect: any Relux.Effect) async {
        let _: Relux.FlowResult = await self.apply(effect)
    }
}
