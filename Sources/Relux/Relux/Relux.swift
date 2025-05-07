@MainActor
public final class Relux: Sendable {
    public let store: Store
    public let rootSaga: RootSaga

    public init(
        logger: (any Relux.Logger),
        appStore: Store = .init(),
        rootSaga: RootSaga = .init()
    ) {
        self.store = appStore
        self.rootSaga = rootSaga
        Relux.Dispatcher.setup(logger: logger)
        Relux.Dispatcher.subscribe(appStore)
        Relux.Dispatcher.subscribe(rootSaga)
    }
}

// register
extension Relux {
    @discardableResult
    public func register(_ module: Module) -> Relux {
        module
            .states
            .forEach { store.connect(state: $0) }

        module
            .sagas
            .forEach { rootSaga.connectSaga(saga: $0) }

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
                await store.disconnect(state: $0)
            }

        module
            .sagas
            .forEach {
                rootSaga.disconnect(saga: $0)
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
