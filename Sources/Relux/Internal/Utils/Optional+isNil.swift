extension Optional where Wrapped: Any {
    var isNil: Bool {
        return self == nil
    }
    var isNotNil: Bool {
        return isNil.not
    }
}

extension Bool {
    var not: Bool {
        return !self
    }
}
