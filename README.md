# Relux

[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux%20%7C%20Android-blue)](#)
[![Swift](https://img.shields.io/badge/Swift-6.2%20%7C%206.1%20%7C%206.0%20%7C%205.10-orange)](#)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)

<div style="font-size: 12px; font-family: Arial, sans-serif; font-style: italic;">
  <p><strong>Relux</strong> /rēˈlʌks/ <em>n.</em></p>
  <ol>
    <li>
      <em>Architecture pattern</em>: Redux's Swift-y cousin who went to actor school and came back async.
    </li>
    <li>
      <em>Framework</em>: Your app's state management therapist - keeps data flowing in one direction, prevents race conditions, and plays nice with SwiftUI.
    </li>
  </ol>
  <p style="margin-top: 8px; font-size: 11px;">
    <em>Etymology: Redux + Relax = Just let the actors handle it™</em>
  </p>
</div>

## Overview

Relux is a Swift package that re-imagines the popular Redux pattern using Swift concurrency. The library embraces the unidirectional data flow (UDF) style while taking advantage of actors and structured concurrency to keep state management safe and predictable.

It can be gradually adopted in existing projects, works seamlessly with SwiftUI, and scales from simple applications to complex modular architectures.


## Core Concepts

### Understanding UDF

UDF stands for *Unidirectional Data Flow*. All changes in the application are triggered by **actions** that are dispatched through a single channel. Each action updates the application module's state, and views observe that state. This one-way flow of information keeps behavior easy to reason about.

### Why Relux?

Relux follows the same principles as Redux but introduces several features tailored for Swift on Apple platforms:

- **Actor-based state and sagas** – every `BusinessState` and `Saga` is an actor. This ensures updates run without data races and enables usage from async contexts.
- **Serial or concurrent dispatch** – actions can be executed sequentially or concurrently using built-in helpers.
- **Modular registration** – a `Module` groups states and sagas and can be registered or removed at runtime, enabling progressive adoption.
- **Effects and flows** – asynchronous work is modeled as `Effect` objects handled by `Saga` or `Flow` actors, separating side effects from pure actions.
- **Enum reflection for logging** – the optional logging interface introspects action enums to print meaningful messages for all effects and actions without manual boilerplate.
- **Reducer inside state** – reducers are instance methods that mutate the state's properties directly. This avoids constant state recreation and keeps logic close to the data it updates.

### State Types

Relux provides three state types, each designed for specific use cases:

**HybridState** – Start here! Combines business logic and UI reactivity in one place. Runs on the main actor, perfect for SwiftUI views. Use this until you need more complexity.

**BusinessState + UIState** – When your app grows, split concerns:
- `BusinessState`: Actor-based, holds your core data and business logic. Not directly observable by SwiftUI.
- `UIState`: Observable wrapper that subscribes to BusinessState changes and transforms data for the UI.

**When to use what:**
- Simple features -> `HybridState` 
- Complex features with shared data -> `BusinessState` + `UIState`
- Need to aggregate and map data from multiple domains -> multiple `BusinessState`'s' + `UIState` instance to subscribe and aggregate

Think of it like cooking: HybridState is your all-in-one pressure cooker, while BusinessState + UIState is your professional kitchen with separate prep and plating stations.

### State Snapshots and Relays

When using the API/Impl modularization pattern, you often want to expose state to consumers without leaking implementation details. Relux provides a snapshot/relay system for this:

**The Problem:**
- Your API module defines *what* data is available (the contract)
- Your Impl module defines *how* that data is managed (the implementation)
- UI consumers should depend only on the API module

**The Solution:**

1. **StateSnapshot** – A lightweight, immutable value type representing a point-in-time view of your state:

```swift
// In your API module
public struct OrientationSnapshot: Relux.StateSnapshot {
    public let orientation: DeviceOrientation
    public let isMonitoring: Bool
}
```

2. **SnapshotProviding** – Protocol for states that emit snapshots:

```swift
// In your Impl module
@MainActor
public final class OrientationState: Relux.HybridState, SnapshotProviding {
    public var current: OrientationSnapshot { /* build snapshot from internal state */ }
    public var snapshots: AsyncStream<OrientationSnapshot> { /* stream of updates */ }
}
```

3. **StateRelaying** – Protocol for objects that relay snapshots to UI. The concrete implementation (`Relux.UI.StateRelay`) lives in swiftui-relux and conforms to `ObservableObject`:

```swift
// In your API module, define a typealias for consumers
public typealias OrientationRelay = Relux.UI.StateRelay<OrientationSnapshot>

// In your Impl module, create the relay
let relay = OrientationRelay(orientationState)
```

4. **Module Integration** – Modules expose relays via the `relays` property:

```swift
public struct OrientationModule: Relux.Module {
    public let states: [any Relux.AnyState]
    public let sagas: [any Relux.Saga]
    public let relays: [any Relux.StateRelaying]

    @MainActor
    public init(state: OrientationState, saga: OrientationSaga) {
        self.states = [state]
        self.sagas = [saga]
        self.relays = [OrientationRelay(state)]
    }
}
```

5. **SwiftUI Usage** – Relays are automatically injected into the environment:

```swift
struct MyView: View {
    @EnvironmentObject var orientationRelay: OrientationRelay

    var body: some View {
        Text("Orientation: \(orientationRelay.value.orientation)")
    }
}
```

**Benefits:**
- Clean API/Impl separation with compile-time enforcement
- Type-safe relay lookup via `store.getRelay(for: OrientationSnapshot.self)`
- Automatic duplicate prevention (one relay per snapshot type)
- Relays subscribe to state streams and republish for SwiftUI observation

### Modules and Sagas

Relux encourages dividing your codebase into feature modules. A `Module` bundles states, sagas or flows, and supporting services. Sagas orchestrate effects such as network requests, while services encapsulate integrations with APIs, databases, sensors etc. Modules can be registered at runtime and expose states ready for consumption by the UI or by other modules.

## Documentation

- [Sample App](https://github.com/ivalx1s/relux-sample) - Full-featured example application
- [API Reference](https://github.com/ivalx1s/darwin-relux/wiki) - Coming soon
- [Architecture Guide](https://github.com/ivalx1s/darwin-relux/wiki) - Coming soon

## Requirements

- Swift 5.10+
- iOS 13.0+, macOS 10.15+, tvOS 13.0+, watchOS 6.0+

## Diagram

<img width="634" alt="redux-architecture" src="https://user-images.githubusercontent.com/11797926/204153109-1bc9a581-48aa-4bdd-a718-f6bdbac3e665.png">


## License

Relux is released under the [MIT License](LICENSE).
