
extension Sequence where Element: Equatable & Hashable {
    var asSet: Set<Element> {
        Set(self)
    }
}
