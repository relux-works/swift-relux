public extension Relux {
    protocol State: Actor, TypeKeyable {
		func reduce(with action: any Relux.Action) async
		
		func cleanup() async
	}
}
