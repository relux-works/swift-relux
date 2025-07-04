import Foundation

extension Relux.Testing {
    public actor MockModule<A: Relux.Action, E: Relux.Effect, Phantom>: Relux.Module {
        public let actionsLogger: State
        public let effectsLogger: Saga

        public let states: [any Relux.AnyState]
        public let sagas: [any Relux.Saga]

        public init() async {
            let actionsLogger = State()
            self.actionsLogger = actionsLogger
            self.states = [actionsLogger]

            let effectsLogger = Saga()
            self.effectsLogger = effectsLogger
            self.sagas = [effectsLogger]
        }
    }
}



