import Foundation

extension Relux {
	@resultBuilder
	public struct SagasBuilder {
		public static func buildBlock() -> [any ReluxSaga] { [] }
		
		public static func buildBlock(_ sagas: any ReluxSaga...) -> [any ReluxSaga] {
			sagas
		}
	}
}

public protocol ReluxSaga: Sendable {
    func apply(_ effect: ReluxEffect) async
}

extension Relux {
	public actor RootSaga: ADSubscriber {
        private var sagas: [any ReluxSaga] = []

        public init() {
            Relux.AD.connect(self)
        }

        public func add(saga: any ReluxSaga) {
            sagas.append(saga)
        }

        public func notify(_ action: ReluxAction) async {
            guard let effect = action as? ReluxEffect else {
                return
            }

            await sagas
                .concurrentForEach { await $0.apply(effect) }
        }
    }
}
