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

These additions keep Relux close to the classic Redux mental model while embracing Swift's modern concurrency features.

Unlike traditional Redux, Relux does **not** recreate state objects on every change. Each state is an actor or class instance that mutates its own properties inside the reducer. The reducer itself is a method of that state, not a standalone function. This approach keeps thread safety and predictability while avoiding excessive copying. It offers pragmatic performance benefits, marrying functional-style clarity with the mutable nature of the underlying system.

## Quick Example

```swift
// from the demo app: https://github.com/ivalx1s/relux-sample
@main
struct SampleApp: App {
    init() { Registry.configure() }

    var body: some Scene {
        WindowGroup {
            Relux.Resolver(
                splash: { Splash() },
                content: { relux in
                    Root.Container(relux: relux)
                        .task { await setupContext() }
                },
                resolver: { await Registry.resolveAsync(Relux.self) }
            )
        }
    }

    private func setupContext() async {
        await actions(.concurrently) {
            SampleApp.Business.Effect.setAppContext
            Auth.Business.Effect.obtainAvailableBiometryType
        }
    }
}
```

## Requirements

- Swift 5.10+
- iOS 13.0+, macOS 10.15+, tvOS 13.0+, watchOS 6.0+

## License

Relux is released under the [MIT License](link-to-license).

## Architecture diagram

<img width="634" alt="redux-architecture" src="https://user-images.githubusercontent.com/11797926/204153109-1bc9a581-48aa-4bdd-a718-f6bdbac3e665.png">

