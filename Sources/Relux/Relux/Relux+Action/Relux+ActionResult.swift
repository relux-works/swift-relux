extension Relux {
    public enum ActionResult: Sendable {
        case success(payload: Payload = .init())
        case failure(payload: ErrPayload = .init())
    }
}

extension Relux.ActionResult {
    public static func success<Value: Sendable>(_ data: Value, from function: String = #function) -> Self {
        success(data, for: function)
    }

    public static func success<Value: Sendable>(_ data: Value, for key: AnyHashable) -> Self {
        .success(payload: .init(data: [key: data]))
    }

    public static func failure(_ error: Error, from function: String = #function) -> Self {
        failure(error, for: function)
    }

    public static func failure(_ error: Error, for key: AnyHashable) -> Self {
        .failure(
            payload: .init(data: [key: error])
        )
    }
}

extension Relux.ActionResult {
    public struct ErrPayload: @unchecked Sendable {
        public let data: [AnyHashable: Error]
        public var errors: [Error] { data.lazy.elements.map { $0.value } }
        public init(
            data: [AnyHashable: Error] = [:]
        ) {
            self.data = data
        }
    }

    public struct Payload: @unchecked Sendable {
        public let data: [AnyHashable: Sendable]
        public init(
            data: [AnyHashable: Sendable] = [:]
        ) {
            self.data = data
        }

        public func data<Data: Sendable>(for key: AnyHashable) -> Data? {
            switch self.data[key] {
                case let .some(val): val as? Data
                case .none: .none
            }
        }
    }
}

extension Relux.ActionResult {
    public static let success: Self = .success()
    public static let failure: Self = .failure()
}

extension Relux.ActionResult {
    var errPayload: ErrPayload? {
        switch self {
            case .success: .none
            case let .failure(payload): payload
        }
    }

    var payload: Payload? {
        switch self {
            case let .success(payload): payload
            case .failure: .none
        }
    }
}
