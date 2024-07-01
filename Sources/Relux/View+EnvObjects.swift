import SwiftUI

extension View {
    public func addViewStatesToEnv(from store: Relux.Store) -> some View {
        var newView: any View = self
        store.viewStates.forEach { pair in
            let viewState = pair.value as any ObservableObject
            newView = newView.environmentObject(viewState)
        }
        return AnyView(newView)
    }
}
