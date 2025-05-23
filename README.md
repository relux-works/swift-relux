# Relux

![Swift](https://img.shields.io/badge/Swift-5.10+-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS-lightgray.svg)
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
