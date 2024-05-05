public protocol ReluxState {
    func reduce(with action: ReluxAction) async

    func cleanup() async
}
