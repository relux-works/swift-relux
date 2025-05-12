extension Sequence where Element == Relux.ActionResult {
    var fails: [Relux.ActionResult.ErrPayload] {
        self.compactMap { $0.errPayload }
    }

    var successes: [Relux.ActionResult.Payload] {
        self.compactMap { $0.payload }
    }

    var reducedResult: Relux.ActionResult {
        switch self.fails.isEmpty {
            case true: .success(payload: successes.merge)
            case false: .failure(payload: fails.merge)
        }
    }
}

extension Sequence where Element == Relux.ActionResult.Payload {
    var merge: Relux.ActionResult.Payload {
        self.reduce(into: .init()) { result, payload in
            result = .init(
                data: result.data.merging(payload.data, uniquingKeysWith: {_, new in new })
            )
        }
    }
}

extension Sequence where Element == Relux.ActionResult.ErrPayload {
    var merge: Relux.ActionResult.ErrPayload {
        self.reduce(into: .init()) { result, payload in
            result = .init(
                data: result.data.merging(payload.data, uniquingKeysWith: {_, new in new })
            )
        }
    }
}
