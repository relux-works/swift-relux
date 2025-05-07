extension Relux {
    public typealias Success = Void
    public typealias ActionResult = Result<Success, Error>
    public typealias FlowResult = ActionResult
}

extension Relux.ActionResult {
    struct AccumulativeFail: Error {
        let errors: [Error]
    }
}

extension Relux.ActionResult {
    public static let success: Relux.ActionResult = .success(Success())

    var isSuccess: Bool {
        switch self {
            case .success: true
            case .failure: false
        }
    }
    var isFail: Bool {
        switch self {
            case .success: false
            case .failure: true
        }
    }
    var fail: Error? {
        switch self {
            case .success: .none
            case let .failure(err): err
        }
    }
}

extension Sequence where Element == Relux.ActionResult {
    var allSucceeded: Bool { allSatisfy(\.isSuccess) }
    var hasFail: Bool { contains(where: \.isFail) }
    var fails: [Error] { self.compactMap { $0.fail } }

    var reducedResult: Relux.ActionResult {
        let fails = self.fails
        return switch fails.isEmpty {
            case true: .success
            case false: .failure(Relux.ActionResult.AccumulativeFail(errors: fails))
        }
    }
}
