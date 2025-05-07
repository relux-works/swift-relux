extension Relux {
    public enum ActionResult: Sendable {
        public typealias Payload = Sendable

        case success(payload: Payload = Void())
        case failure(Error)
    }
}

extension Relux.ActionResult {
    public static let success: Self = .success()

    struct Fail: Error {
        let errors: [Error]
    }
}

extension Relux.ActionResult {
    var fail: Error? {
        switch self {
            case .success: .none
            case let .failure(err): err
        }
    }
}

extension Sequence where Element == Relux.ActionResult {
    var fails: [Error] { self.compactMap { $0.fail } }

    var reducedResult: Relux.ActionResult {
        switch self.fails.isEmpty {
            case true: .success
            case false: .failure(Relux.ActionResult.Fail(errors: self.fails))
        }
    }
}
