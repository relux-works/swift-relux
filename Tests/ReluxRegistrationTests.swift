import Testing
@testable import Relux

@Suite("Relux registration")
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
