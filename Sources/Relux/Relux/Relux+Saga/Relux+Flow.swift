extension Relux {
    public protocol Flow: Saga {
        typealias Result = ActionResult

        @discardableResult
        func apply(_ effect: any Relux.Effect) async -> Self.Result
    }
}

extension Relux.Flow {
    public func apply(_ effect: any Relux.Effect) async {
        let _: Relux.ActionResult = await self.apply(effect)
    }
}
