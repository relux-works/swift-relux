---
title: Relux
summary: A unidirectional data-flow architecture for Swift 6 concurrency.
category: Architecture libraries
featured: true
---

## What it is

Relux is a unidirectional data-flow architectural library for Swift, designed around
Swift 6's strict concurrency model and tailored for SwiftUI. State lives in predictable
containers, changes flow one way through actions and middleware, and the whole thing is
type-safe and testable by construction.

## Why it matters

Predictable architecture is what makes AI-assisted development safe at speed. When state
transitions are explicit and one-directional, an agent (or a human) can reason about a
change without holding the whole app in their head, and tests pin the behavior in place.
Relux is the backbone of a family of Swift modules — routing, error handling, analytics,
feature flags, networking — that share the same discipline.

## Who it is for

Swift teams who want the guarantees of a Redux-style architecture with first-class Swift
concurrency, not a port of a JavaScript pattern.
