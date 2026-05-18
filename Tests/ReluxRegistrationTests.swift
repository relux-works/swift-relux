import Testing
@testable import Relux

@Suite("Relux registration", .serialized)
@MainActor
struct ReluxRegistrationTests {
    @Test func registerArrayConnectsEveryModule() async {
        Relux.shared = nil
        defer { Relux.shared = nil }

        let relux = await Relux(logger: Relux.Testing.Logger())
        let first = await Relux.Testing.MockModule<FirstAction, FirstEffect, FirstModule>()
        let second = await Relux.Testing.MockModule<SecondAction, SecondEffect, SecondModule>()
        let firstState = await first.actionsLogger
        let secondState = await second.actionsLogger
        let firstSaga = await first.effectsLogger
        let secondSaga = await second.effectsLogger

        relux.register([first, second])

        #expect(relux.store.businessStates[firstState.key] != nil)
        #expect(relux.store.businessStates[secondState.key] != nil)

        await relux.dispatcher.action {
            FirstAction.ping
        }
        #expect(await firstState.actions.count == 1)
        #expect(await secondState.actions.count == 1)

        await relux.dispatcher.action {
            FirstEffect.ping
        }
        #expect(await firstSaga.effects.count == 1)
        #expect(await secondSaga.effects.count == 1)
    }

    @Test func registerSameModuleTwiceDoesNotReconnectStatesOrSagas() async {
        Relux.shared = nil
        defer { Relux.shared = nil }

        let relux = await Relux(logger: Relux.Testing.Logger())
        let module = await Relux.Testing.MockModule<FirstAction, FirstEffect, FirstModule>()
        let state = await module.actionsLogger
        let saga = await module.effectsLogger

        relux.register(module)
        relux.register(module)

        await relux.dispatcher.action {
            FirstAction.ping
        }
        #expect(await state.actions.count == 1)

        await relux.dispatcher.action {
            FirstEffect.ping
        }
        #expect(await saga.effects.count == 1)
    }

    @Test func registerSameModuleIdentityTwiceDoesNotConnectSecondInstance() async {
        Relux.shared = nil
        defer { Relux.shared = nil }

        let relux = await Relux(logger: Relux.Testing.Logger())
        let firstModule = await Relux.Testing.MockModule<FirstAction, FirstEffect, FirstModule>()
        let secondModule = await Relux.Testing.MockModule<FirstAction, FirstEffect, FirstModule>()
        let firstState = await firstModule.actionsLogger
        let secondState = await secondModule.actionsLogger
        let firstSaga = await firstModule.effectsLogger
        let secondSaga = await secondModule.effectsLogger

        relux.register(firstModule)
        relux.register(secondModule)

        await relux.dispatcher.action {
            FirstAction.ping
        }
        #expect(await firstState.actions.count == 1)
        #expect(await secondState.actions.isEmpty)

        await relux.dispatcher.action {
            FirstEffect.ping
        }
        #expect(await firstSaga.effects.count == 1)
        #expect(await secondSaga.effects.isEmpty)
    }

    @Test func registerModuleConnectsDependencies() async {
        Relux.shared = nil
        defer { Relux.shared = nil }

        let relux = await Relux(logger: Relux.Testing.Logger())
        let dependency = await Relux.Testing.MockModule<FirstAction, FirstEffect, DependencyModule>()
        let dependencyState = await dependency.actionsLogger
        let dependencySaga = await dependency.effectsLogger
        let owner = ModuleWithDependencies<OwnerModule>(dependencies: [dependency])

        relux.register(owner)

        #expect(relux.store.businessStates[dependencyState.key] != nil)

        await relux.dispatcher.action {
            FirstAction.ping
        }
        #expect(await dependencyState.actions.count == 1)

        await relux.dispatcher.action {
            FirstEffect.ping
        }
        #expect(await dependencySaga.effects.count == 1)
    }

    @Test func unregisterModuleWithDependencyDisconnectsBothWhenItIsTheOnlyOwner() async {
        Relux.shared = nil
        defer { Relux.shared = nil }

        let relux = await Relux(logger: Relux.Testing.Logger())
        let diagnostics = FeatureModule<DiagnosticsModule>()
        let tap2Cash = FeatureModule<Tap2CashModule>(dependencies: [diagnostics])

        relux.register(tap2Cash)

        #expect(relux.store.businessStates[tap2Cash.state.key] != nil)
        #expect(relux.store.businessStates[diagnostics.state.key] != nil)

        await relux.unregister(tap2Cash)

        #expect(relux.store.businessStates[tap2Cash.state.key] == nil)
        #expect(relux.store.businessStates[diagnostics.state.key] == nil)

        await relux.dispatcher.action {
            FirstAction.ping
        }
        #expect(await tap2Cash.state.actions.isEmpty)
        #expect(await diagnostics.state.actions.isEmpty)

        await relux.dispatcher.action {
            FirstEffect.ping
        }
        #expect(await tap2Cash.saga.effects.isEmpty)
        #expect(await diagnostics.saga.effects.isEmpty)
    }

    @Test func unregisterOneFeatureModuleKeepsSharedDependencyForAnotherFeatureModule() async {
        Relux.shared = nil
        defer { Relux.shared = nil }

        let relux = await Relux(logger: Relux.Testing.Logger())
        let diagnostics = FeatureModule<DiagnosticsModule>()
        let tap2Cash = FeatureModule<Tap2CashModule>(dependencies: [diagnostics])
        let auth = FeatureModule<AuthModule>(dependencies: [diagnostics])

        relux.register([tap2Cash, auth])

        #expect(relux.store.businessStates[tap2Cash.state.key] != nil)
        #expect(relux.store.businessStates[auth.state.key] != nil)
        #expect(relux.store.businessStates[diagnostics.state.key] != nil)

        await relux.unregister(tap2Cash)

        #expect(relux.store.businessStates[tap2Cash.state.key] == nil)
        #expect(relux.store.businessStates[auth.state.key] != nil)
        #expect(relux.store.businessStates[diagnostics.state.key] != nil)

        await relux.dispatcher.action {
            FirstAction.ping
        }
        #expect(await tap2Cash.state.actions.isEmpty)
        #expect(await auth.state.actions.count == 1)
        #expect(await diagnostics.state.actions.count == 1)

        await relux.dispatcher.action {
            FirstEffect.ping
        }
        #expect(await tap2Cash.saga.effects.isEmpty)
        #expect(await auth.saga.effects.count == 1)
        #expect(await diagnostics.saga.effects.count == 1)

        let authActionsBeforeFinalUnregister = await auth.state.actions.count
        let diagnosticsActionsBeforeFinalUnregister = await diagnostics.state.actions.count
        let authEffectsBeforeFinalUnregister = await auth.saga.effects.count
        let diagnosticsEffectsBeforeFinalUnregister = await diagnostics.saga.effects.count

        await relux.unregister(auth)

        #expect(relux.store.businessStates[auth.state.key] == nil)
        #expect(relux.store.businessStates[diagnostics.state.key] == nil)

        await relux.dispatcher.action {
            FirstAction.ping
        }
        #expect(await auth.state.actions.count == authActionsBeforeFinalUnregister)
        #expect(await diagnostics.state.actions.count == diagnosticsActionsBeforeFinalUnregister)

        await relux.dispatcher.action {
            FirstEffect.ping
        }
        #expect(await auth.saga.effects.count == authEffectsBeforeFinalUnregister)
        #expect(await diagnostics.saga.effects.count == diagnosticsEffectsBeforeFinalUnregister)
    }

    @Test func sharedDependencyIsRegisteredOnce() async {
        Relux.shared = nil
        defer { Relux.shared = nil }

        let relux = await Relux(logger: Relux.Testing.Logger())
        let dependency = await Relux.Testing.MockModule<FirstAction, FirstEffect, DependencyModule>()
        let dependencyState = await dependency.actionsLogger
        let dependencySaga = await dependency.effectsLogger
        let firstOwner = ModuleWithDependencies<FirstOwnerModule>(dependencies: [dependency])
        let secondOwner = ModuleWithDependencies<SecondOwnerModule>(dependencies: [dependency])

        relux.register([firstOwner, secondOwner])

        await relux.dispatcher.action {
            FirstAction.ping
        }
        #expect(await dependencyState.actions.count == 1)

        await relux.dispatcher.action {
            FirstEffect.ping
        }
        #expect(await dependencySaga.effects.count == 1)
    }

    @Test func unregisteringOneOwnerKeepsSharedDependencyRegistered() async {
        Relux.shared = nil
        defer { Relux.shared = nil }

        let relux = await Relux(logger: Relux.Testing.Logger())
        let dependency = await Relux.Testing.MockModule<FirstAction, FirstEffect, DependencyModule>()
        let dependencyState = await dependency.actionsLogger
        let dependencySaga = await dependency.effectsLogger
        let firstOwner = ModuleWithDependencies<FirstOwnerModule>(dependencies: [dependency])
        let secondOwner = ModuleWithDependencies<SecondOwnerModule>(dependencies: [dependency])

        relux.register([firstOwner, secondOwner])
        await relux.unregister(firstOwner)

        #expect(relux.store.businessStates[dependencyState.key] != nil)

        await relux.dispatcher.action {
            FirstAction.ping
        }
        #expect(await dependencyState.actions.count == 1)

        await relux.dispatcher.action {
            FirstEffect.ping
        }
        #expect(await dependencySaga.effects.count == 1)
    }

    @Test func unregisteringFinalOwnerDisconnectsSharedDependency() async {
        Relux.shared = nil
        defer { Relux.shared = nil }

        let relux = await Relux(logger: Relux.Testing.Logger())
        let dependency = await Relux.Testing.MockModule<FirstAction, FirstEffect, DependencyModule>()
        let dependencyState = await dependency.actionsLogger
        let dependencySaga = await dependency.effectsLogger
        let firstOwner = ModuleWithDependencies<FirstOwnerModule>(dependencies: [dependency])
        let secondOwner = ModuleWithDependencies<SecondOwnerModule>(dependencies: [dependency])

        relux.register([firstOwner, secondOwner])
        await relux.unregister(firstOwner)
        await relux.unregister(secondOwner)

        #expect(relux.store.businessStates[dependencyState.key] == nil)

        await relux.dispatcher.action {
            FirstAction.ping
        }
        #expect(await dependencyState.actions.isEmpty)

        await relux.dispatcher.action {
            FirstEffect.ping
        }
        #expect(await dependencySaga.effects.isEmpty)
    }
}

private enum FirstAction: Relux.Action {
    case ping
}

private enum SecondAction: Relux.Action {
    case ping
}

private enum FirstEffect: Relux.Effect {
    case ping
}

private enum SecondEffect: Relux.Effect {
    case ping
}

private enum FirstModule {}

private enum SecondModule {}

private enum DependencyModule {}

private enum OwnerModule {}

private enum DiagnosticsModule {}

private enum Tap2CashModule {}

private enum AuthModule {}

private enum FirstOwnerModule {}

private enum SecondOwnerModule {}

private struct ModuleWithDependencies<Marker>: Relux.Module {
    let dependencies: [any Relux.Module]
    let states: [any Relux.AnyState] = []
    let sagas: [any Relux.Saga] = []
}

private struct FeatureModule<Marker>: Relux.Module {
    let dependencies: [any Relux.Module]
    let state: FeatureState<Marker>
    let saga: FeatureSaga<Marker>
    let states: [any Relux.AnyState]
    let sagas: [any Relux.Saga]

    init(dependencies: [any Relux.Module] = []) {
        self.dependencies = dependencies

        let state = FeatureState<Marker>()
        self.state = state
        self.states = [state]

        let saga = FeatureSaga<Marker>()
        self.saga = saga
        self.sagas = [saga]
    }
}

private actor FeatureState<Marker>: Relux.BusinessState {
    var actions: [any Relux.Action] = []

    func reduce(with action: any Relux.Action) async {
        actions.append(action)
    }

    func cleanup() async {}
}

private actor FeatureSaga<Marker>: Relux.Saga {
    var effects: [any Relux.Effect] = []

    func apply(_ effect: any Relux.Effect) async {
        effects.append(effect)
    }
}
