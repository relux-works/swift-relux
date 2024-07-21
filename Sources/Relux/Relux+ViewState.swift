import SwiftUI

public protocol ReluxViewState: ObservableObject, Sendable {}


#if canImport(Observation)
import Observation
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol ReluxViewStateObserving: Observable, Sendable {}
#endif
