import Foundation

extension Relux { public enum Testing {} }

extension Relux.Testing {
    public actor MockModule<A: Relux.Action, E: Relux.Effect, Phantom>: Relux.Module {
        public let actionsLogger: State
        public let effectsLogger: Saga

        public let states: [any Relux.State]
        public let uistates: [any Relux.Presentation.StatePresenting] = []
        public let sagas: [any Relux.Saga]
        public let routers: [any Relux.Navigation.RouterProtocol] = []

        public init() {
            let actionsLogger = State()
            self.actionsLogger = actionsLogger
            self.states = [actionsLogger]

            let effectsLogger = Saga()
            self.effectsLogger = effectsLogger
            self.sagas = [effectsLogger]
        }
    }
}



