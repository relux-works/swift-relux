@MainActor
public final class Relux: Sendable {
    public let store: Store
    public let rootSaga: RootSaga
    public let dispatcher: Dispatcher

    public static var shared: Relux!

    private var moduleRegistrations: [Relux.ModuleKey: ModuleRegistration] = [:]
    private var registeringModuleKeys: Set<Relux.ModuleKey> = []

    public convenience init(
        logger: (any Relux.Logger)
    ) async {
        await self.init(
            logger: logger,
            appStore: .init(),
            rootSaga: .init()
        )
    }

    public init(
        logger: (any Relux.Logger),
        appStore: Store,
        rootSaga: RootSaga
    ) async {
        self.store = appStore
        self.rootSaga = rootSaga
        self.dispatcher = .init(
            subscribers: [appStore, rootSaga],
            logger: logger
        )

        guard Self.shared.isNil
        else { fatalError("only one instance of Relux is allowed") }
        Self.shared = self
    }
}

// register
extension Relux {
    @discardableResult
    public func register(_ modules: [Module]) -> Relux {
        modules
            .forEach { self.register($0) }
        return self
    }

    @discardableResult
    public func register(_ module: Module) -> Relux {
        retain(module, owner: module.moduleKey)

        return self
    }

    private func retain(_ module: any Module, owner: Relux.ModuleKey) {
        let moduleKey = module.moduleKey
        var registration = moduleRegistrations[moduleKey] ?? ModuleRegistration(module: module)
        registration.owners.insert(owner)
        moduleRegistrations[moduleKey] = registration

        guard
            registration.isConnected.not,
            registeringModuleKeys.contains(moduleKey).not
        else { return }

        registeringModuleKeys.insert(moduleKey)
        defer { registeringModuleKeys.remove(moduleKey) }

        registration
            .module
            .dependencies
            .forEach { retain($0, owner: moduleKey) }

        guard var currentRegistration = moduleRegistrations[moduleKey],
              currentRegistration.isConnected.not
        else {
            return
        }

        currentRegistration.isConnected = true
        moduleRegistrations[moduleKey] = currentRegistration

        currentRegistration
            .module
            .states
            .forEach { self.store.connect(state: $0) }

        currentRegistration
            .module
            .sagas
            .forEach { self.rootSaga.connectSaga(saga: $0) }
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
        await release(moduleKey: module.moduleKey, owner: module.moduleKey)

        return self
    }

    private func release(moduleKey: Relux.ModuleKey, owner: Relux.ModuleKey) async {
        guard var registration = moduleRegistrations[moduleKey],
              registration.owners.remove(owner).isNil.not
        else { return }

        guard registration.owners.isEmpty else {
            moduleRegistrations[moduleKey] = registration
            return
        }

        moduleRegistrations.removeValue(forKey: moduleKey)

        if registration.isConnected {
            await registration
                .module
                .states
                .asyncForEach {
                    await self.store.disconnect(state: $0)
                }

            registration
                .module
                .sagas
                .forEach {
                    self.rootSaga.disconnect(saga: $0)
                }
        }

        for dependency in registration.module.dependencies {
            await release(moduleKey: dependency.moduleKey, owner: moduleKey)
        }
    }
}

extension Relux {
    private struct ModuleRegistration {
        let module: any Relux.Module
        var owners: Set<Relux.ModuleKey> = []
        var isConnected = false
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
