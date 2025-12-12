@MainActor
public final class Relux: Sendable {
    public let store: Store
    public let rootSaga: RootSaga
    public let dispatcher: Dispatcher

    public static var shared: Relux!

        public init(
            logger: (any Relux.Logger),
            appStore: Store = .init(),
            rootSaga: RootSaga = .init(),
            bindToShared: Bool = true
        ) async {
            self.store = appStore
            self.rootSaga = rootSaga
            self.dispatcher = .init(
                subscribers: [appStore, rootSaga],
                logger: logger
            )
    
            if bindToShared {
                guard Self.shared.isNil
                else { fatalError("only one instance of Relux is allowed. To create a test instance, pass bindToShared: false") }
                Self.shared = self
            }
        }
    }
// register
extension Relux {
    @discardableResult
    public func register(_ module: Module) -> Relux {
        module
            .states
            .forEach { self.store.connect(state: $0) }

        module
            .sagas
            .forEach { self.rootSaga.connectSaga(saga: $0) }

        module
            .relays // todo: rename to state snapshot relays
            .forEach { self.store.connect(relay: $0) }

        module
            .actionRelays
            .forEach { self.store.connect(actionRelay: $0) }

        return self
    }

    @discardableResult
    public func register(@Relux.ModuleResultBuilder _ modules: @Sendable () async -> [Relux.Module]) async -> Relux {
        await modules()
            .forEach { register($0) }

        return self
    }
}

// unregister
extension Relux {
    @discardableResult
    public func unregister(_ module: Module) async -> Relux {
        await module
            .states
            .asyncForEach {
                await self.store.disconnect(state: $0)
            }

        module
            .sagas
            .forEach {
                self.rootSaga.disconnect(saga: $0)
            }

        return self
    }

}

// modules builder
extension Relux {
    @resultBuilder
    public struct ModuleResultBuilder {
        public static func buildBlock() -> [any Module] { [] }

        public static func buildBlock(_ modules: any Module...) -> [any Module] {
            modules
        }
    }
}
