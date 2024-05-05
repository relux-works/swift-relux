import Foundation

public final class Relux {
    public let appStore: Store
    public let rootSaga: RootSaga

    public init(
        appStore: Store = .init(),
        rootSaga: RootSaga = .init()
    ) {
        self.appStore = appStore
        self.rootSaga = rootSaga
    }

    public func register(_ module: Module) -> Relux {
        module.states
            .forEach { appStore.connectState(state: $0) }
        module.viewStates
            .forEach { appStore.connectViewState(state: $0) }
        module.sagas
            .forEach { rootSaga.add(saga: $0) }

        return self
    }
}

extension Relux {
    open class Module {
        let states: [ReluxState]
        let viewStates: [any ReluxViewState]
        let sagas: [ReluxSaga]

        public init(
            states: [ReluxState] = [],
            viewStates: [any ReluxViewState] = [],
            sagas: [ReluxSaga] = []
        ) {
            self.states = states
            self.viewStates = viewStates
            self.sagas = sagas
        }
    }
}
