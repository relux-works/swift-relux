---
title: Relux
summary: A unidirectional data-flow architecture for Swift 6, and the core of our rapid-MVP stack.
category: Relux stack
featured: true
---

## What it is

Relux is a unidirectional data-flow architectural library for Swift, designed around
Swift 6's strict concurrency model and tailored for SwiftUI. State lives in predictable
containers, changes flow one way through actions and middleware, and the whole thing is
type-safe and testable by construction.

## Why it matters

Relux is the core of the stack we use to build MVPs fast on agentic rails and then
scale them into enterprise-grade apps. Predictable one-way state transitions are what
make AI-assisted development safe at speed: an agent, like a human, can reason about a
change without holding the whole app in its head, and tests pin the behavior in place.
Around the core sits a family of modules that share the discipline (routing, error
handling, analytics, feature flags, networking, files), agent-ready testing tools, and
an enterprise growth path with Tuist workspaces and strict modularization. The
architecture has been proven in production for years.

## Who it is for

Swift teams who want a Redux-style architecture with first-class Swift concurrency,
and founders who want an MVP that will not need a rewrite when it becomes the product.
