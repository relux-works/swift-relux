# Relux

<div style="font-size: 12px; font-family: Arial, sans-serif; font-style: italic;">
  <p><strong>Relux</strong> /rēˈlʌks/ <em>n.</em></p>
  <ol>
    <li>
      An architectural approach for developing applications on Apple platforms, characterized by:
      <ol type="a">
        <li>Safety: Utilizes Swift 6's concurrency model to ensure data-race safety.</li>
        <li>Modularity: Promotes clear separation of concerns and modular design.</li>
        <li>Scalability: Supports growth from small projects to large-scale applications.</li>
        <li>Asynchronicity: Leverages Swift's structured concurrency for efficient asynchronous operations.</li>
      </ol>
    </li>
    <li>
      A framework implementing the Relux approach, featuring:
      <ol type="a">
        <li>Unidirectional data flow.</li>
        <li>Compatibility with SwiftUI.</li>
        <li>Progressive adoption capabilities.</li>
        <li>Service-oriented architecture principles.</li>
      </ol>
    </li>
  </ol>
</div>

## Overview

Relux is a Swift package that re-imagines the popular Redux pattern using Swift concurrency. The library embraces the unidirectional data flow (UDF) style while taking advantage of actors and structured concurrency to keep state management safe and predictable.

It can be gradually adopted in existing projects, works seamlessly with SwiftUI, and scales from simple applications to complex modular architectures.

## Understanding UDF

UDF stands for *Unidirectional Data Flow*. All changes in the application are triggered by **actions** that are dispatched through a single channel. Each action updates the application's state, and views observe that state. This one-way flow of information keeps behavior easy to reason about.

## Why Relux?

Relux follows the same principles as Redux but introduces several features tailored for Swift on Apple platforms:

- **Actor-based state and sagas** – every `BusinessState` and `Saga` is an actor. This ensures updates run without data races and enables usage from async contexts.
- **Serial or concurrent dispatch** – actions can be executed sequentially or concurrently using built-in helpers.
- **Modular registration** – a `Module` groups states and sagas and can be registered or removed at runtime, enabling progressive adoption.
- **Effects and flows** – asynchronous work is modeled as `Effect` objects handled by `Saga` or `Flow` actors, separating side effects from pure actions.
- **Enum reflection for logging** – the optional logging interface introspects action enums to print meaningful messages without manual boilerplate.
- **Reducer inside state** – reducers are instance methods that mutate the state's properties directly. This avoids constant state recreation and keeps logic close to the data it updates.

These additions keep Relux close to the classic Redux mental model while embracing Swift's modern concurrency features.

## State Types

Relux comes with three categories of state objects to fit different scenarios:

- **HybridState** – the go‑to option. It runs on the main actor and exposes a reducer method for safe mutation, making it perfect for SwiftUI views.
- **BusinessState** – an actor that holds domain data. Use it when logic needs isolation from the main actor or may be shared across multiple UI layers.
- **UIState** – aggregates or transforms data from one or more `BusinessState` instances through reactive pipelines. Pick this when the UI requires complex data projections.

Start with a `HybridState` and split into `BusinessState` plus `UIState` as the app grows and view requirements become more involved.

## Modules and Sagas

Relux encourages dividing your codebase into feature modules. A `Module` bundles states, sagas or flows, and supporting services. Sagas orchestrate effects such as network requests, while services encapsulate integrations with APIs or databases. Modules can be registered at runtime and expose states ready for consumption by the UI or by other modules.

## Quick Example

```swift
struct Increment: Relux.Action {}

actor CounterState: Relux.BusinessState {
    var count = 0
    func reduce(with action: any Relux.Action) async {
        switch action {
        case is Increment: count += 1
        default: break
        }
    }
    func cleanup() async {}
}

struct CounterModule: Relux.Module {
    let states: [any Relux.AnyState] = [CounterState()]
    let sagas: [any Relux.Saga] = []
}

let relux = Relux(logger: MyLogger())
await relux.register { CounterModule() }

// somewhere in the UI
await action { Increment() }
```

## Requirements

- Swift 5.10+
- iOS 13.0+, macOS 10.15+, tvOS 13.0+, watchOS 6.0+

## License

Relux is released under the [MIT License](link-to-license).

## Architecture diagram

<img width="634" alt="redux-architecture" src="https://user-images.githubusercontent.com/11797926/204153109-1bc9a581-48aa-4bdd-a718-f6bdbac3e665.png">

