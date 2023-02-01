import SwiftUI

public extension AsyncButton {
	
	init(
		actionPriority: TaskPriority? = nil,
		actionOptions: Set<AsyncButton<Label>.ActionOption> = [ActionOption.disableButton],
		action: PerduxAction,
		@ViewBuilder label: @escaping () -> Label
	) {
		self.init(
			actionPriority: actionPriority,
			actionOptions: actionOptions,
			action: { await Perdux.action { action } },
			label: label
		)
	}
	
}
