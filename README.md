# GraphFSM

**GraphFSM** is a lightweight, graph-driven finite state machine library for Swift.
It cleanly separates **FSM definition** from **FSM usage**, allowing you to declare your state graph in one place and instantiate it anywhere else.

This design is ideal for complex UI flows, media players, workflow engines, navigation logic, and anywhere you want deterministic state transitions without reactive spaghetti.

---

## Why GraphFSM?

Most Swift state machine libraries force state transitions to be defined inline with the machine instance, making it difficult to:

- Separate **FSM declaration** from **FSM usage**
- Reuse graphs across modules
- Inspect or visualize transitions
- Test the graph independently

GraphFSM solves this by letting you:

1. **Define a graph** using pure Swift types (State + Event)
2. **Instantiate a machine** with an initial state and transition list
3. **Drive the machine** by sending events
4. **Observe (from / to / any) transitions** through callbacks

---

## Features

- 🚀 **Lightweight** – around a few hundred lines, zero dependencies
- 🧩 **Graph-based** – transitions defined separately from machine instance
- 🎯 **Event-driven** – `handle(event:)` triggers deterministic transitions
- 🔍 **Observable** – register callbacks:
  - `onTransition { ... }`
  - `onTransition(from:) { ... }`
  - `onTransition(to:) { ... }`
  - `onTransition(from:on:) { ... }`
  - `onTransition(to:on:) { ... }`
- 🔒 **Type-safe** – states & events use Swift enums
- 📦 **Supports SPM, CocoaPods, Carthage**
- 📝 **MIT licensed**

---

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
.package(url: "https://github.com/mehdisam/GraphFSM.git", from: "1.0.2")
```

Or in Xcode:
**File → Add Packages…** → enter repository URL.

---

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'GraphFSM', '~> 1.0'
```

Then run:

```
pod install
```

---

### Carthage

Add to `Cartfile`:

```
github "username/GraphFSM" ~> 1.0
```

---

## Usage Example

### 1. Define States and Events

```swift
enum PlayerState {
    case idle
    case loading
    case ready
    case playing
}

enum PlayerEvent {
    case load
    case prepared
    case play
    case stop
}
```

### 2. Define Your Graph Separately

```swift
let graph: [GraphFSM<PlayerState, PlayerEvent>.Transition] = [
    .init(from: .idle,    event: .load,     to: .loading),
    .init(from: .loading, event: .prepared, to: .ready),
    .init(from: .ready,   event: .play,     to: .playing),
    .init(from: .playing, event: .stop,     to: .idle)
]
```

### 3. Create a Machine Instance

```swift
let fsm = GraphFSM(initialState: .idle, transitions: graph)
```

### 4. Register Transition Observers

```swift
fsm.onTransition { t in
    print("Any transition: \(t.from) -> \(t.to)")
}

fsm.onTransition(from: .loading) { t in
    print("Leaving loading")
}

fsm.onTransition(to: .playing) { t in
    print("Now playing!")
}

fsm.onTransition(from: .loading, on: .prepared) { t in
    print("Specifically finished loading via 'prepared' event")
}
```

### 5. Send Events

```swift
fsm.handle(event: .load)
fsm.handle(event: .prepared)
fsm.handle(event: .play)
```

---

## When to Use GraphFSM

GraphFSM is best for cases where business logic must stay predictable even under concurrency, UI noise, and event storms:

- Music / video players
- Record/track loaders
- Multi-step UI workflows
- View models that change state based on user input
- Network request state management
- Reusable flow engines
- Navigation guards

If you’ve ever lost a workflow inside reactive chains (SwiftUI, Combine, async streams), GraphFSM brings back clarity.

---

## Philosophy

GraphFSM is intentionally:

- **Simple** – no async requirements, no protocols, no codegen
- **Transparent** – transition list is just Swift data
- **Decoupled** – graph exists independently from runtime
- **Extensible** – add logging, analytics, or visualization

You keep full control.

---

## License

MIT License.
See `LICENSE` for details.
