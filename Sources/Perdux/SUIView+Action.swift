#if canImport(SwiftUI) && canImport(Perdux)
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {
#if compiler(>=5.3) && $AsyncAwait && $Sendable && $InheritActorContext
	
	@inlinable public func effects(
		priority: _Concurrency.TaskPriority = .userInitiated,
		@PerduxActionCompositionBuilder @_inheritActorContext actions perduxActions: @escaping @Sendable () async -> [PerduxAction],
		delay: @escaping () -> Double = { 0 }
	) -> some View {
		let action: @Sendable () async -> Void = {
			
			let perduxActions = await perduxActions()
			await perduxActions.asyncForEach { perduxAction in
				await Perdux.action {
					perduxAction
				}
			}
		}
		return modifier(_TaskModifier(priority: priority, action: action))
	}
	
	@inlinable public func effect(
		priority: _Concurrency.TaskPriority = .userInitiated,
		@PerduxActionCompositionBuilder @_inheritActorContext actions perduxAction: @escaping @Sendable () async -> PerduxAction,
		delay: @escaping () -> Double = { 0 }
	) -> some View {
		let action: @Sendable () async -> Void = {
			await Perdux.action(delay: delay()) {
				await perduxAction()
			}
		}
		return modifier(_TaskModifier(priority: priority, action: action))
	}
	
#endif
	
}
#endif
