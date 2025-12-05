import Foundation

open class GraphFSM<State: Hashable, Event: Hashable> {
    public struct Transition: Hashable {
        public let from: State
        public let event: Event
        public let to: State
        public init(from: State, event: Event, to: State) {
            self.from = from
            self.event = event
            self.to = to
        }
    }

    private let transitions: Set<Transition>
    public private(set) var currentState: State

    private struct CombinationKey: Hashable {
        let state: State
        let event: Event
    }

    private var onTransitionCallbacks: [(Transition) -> Void] = []
    private var onTransitionFromCallbacks: [State: [(Transition) -> Void]] = [:]
    private var onTransitionToCallbacks: [State: [(Transition) -> Void]] = [:]
    private var onTransitionFromEventCallbacks: [CombinationKey: [(Transition) -> Void]] = [:]
    private var onTransitionToEventCallbacks: [CombinationKey: [(Transition) -> Void]] = [:]

    public init(initialState: State, transitions: [Transition]) {
        self.currentState = initialState
        self.transitions = Set(transitions)
    }

    public func handle(event: Event) {
        guard let transition = transitions.first(where: { $0.from == currentState && $0.event == event }) else {
            print("No transition from \(currentState) on \(event)")
            return
        }
        onTransitionCallbacks.forEach { $0(transition) }
        onTransitionFromCallbacks[transition.from]?.forEach { $0(transition) }
        onTransitionToCallbacks[transition.to]?.forEach { $0(transition) }
        
        let fromKey = CombinationKey(state: transition.from, event: event)
        onTransitionFromEventCallbacks[fromKey]?.forEach { $0(transition) }
        
        let toKey = CombinationKey(state: transition.to, event: event)
        onTransitionToEventCallbacks[toKey]?.forEach { $0(transition) }
        
        currentState = transition.to
    }

    public func onTransition(_ callback: @escaping (Transition) -> Void) {
        onTransitionCallbacks.append(callback)
    }

    public func onTransition(from state: State, callback: @escaping (Transition) -> Void) {
        onTransitionFromCallbacks[state, default: []].append(callback)
    }

    public func onTransition(to state: State, callback: @escaping (Transition) -> Void) {
        onTransitionToCallbacks[state, default: []].append(callback)
    }

    public func onTransition(from state: State, on event: Event, callback: @escaping (Transition) -> Void) {
        let key = CombinationKey(state: state, event: event)
        onTransitionFromEventCallbacks[key, default: []].append(callback)
    }

    public func onTransition(to state: State, on event: Event, callback: @escaping (Transition) -> Void) {
        let key = CombinationKey(state: state, event: event)
        onTransitionToEventCallbacks[key, default: []].append(callback)
    }
}
