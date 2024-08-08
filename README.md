

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

Relux is a unidirectional data flow architectural library for developing robust, modular, and asynchronous applications across Apple platforms. It is designed to work seamlessly with Swift 6's concurrency model and is tailored for use within SwiftUI applications.

Relux provides a flexible approach to app architecture, suitable for developers at all experience levels. It leverages modern Swift features, including Structured Concurrency and data-race safety, to enhance development efficiency and application performance.

## Key Features

- Employs Swift's type system and concurrency primitives for high-performance operations while maintaining Redux-like architectural guarantees.
- Allows integration with existing codebases, supporting gradual implementation alongside other architectural patterns such as MVVM.
- Facilitates growth from small-scale to enterprise-level applications, promoting clean and modular code structure.
- Encourages separation of business logic from views and view lifesycles and promotes service-oriented architectural principles.
- Adapts to various development needs and preferences, avoiding strict opinionated structures.
- Promotes thinking in terms of modules and clear module boundary definitions, enhancing code maintainability.




## Requirements

- Swift 5.10+
- iOS 13.0+, macOS 10.15+, tvOS 13.0+, watchOS 6.0+

## License

Relux is released under the [MIT License](link-to-license).

## Architecture diagram
<img width="634" alt="redux-architecture" src="https://user-images.githubusercontent.com/11797926/204153109-1bc9a581-48aa-4bdd-a718-f6bdbac3e665.png">
