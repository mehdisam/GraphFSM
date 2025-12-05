import XCTest
@testable import GraphFSM

final class GraphFSMTests: XCTestCase {

    enum State {
        case locked
        case unlocked
        case open
    }

    enum Event {
        case coin
        case push
    }

    func testInitialization() {
        let fsm = GraphFSM<State, Event>(initialState: .locked, transitions: [])
        XCTAssertEqual(fsm.currentState, .locked)
    }

    func testValidTransition() {
        let transitions: [GraphFSM<State, Event>.Transition] = [
            .init(from: .locked, event: .coin, to: .unlocked)
        ]
        let fsm = GraphFSM(initialState: .locked, transitions: transitions)

        fsm.handle(event: .coin)
        XCTAssertEqual(fsm.currentState, .unlocked)
    }

    func testInvalidTransition() {
        let transitions: [GraphFSM<State, Event>.Transition] = [
            .init(from: .locked, event: .coin, to: .unlocked)
        ]
        let fsm = GraphFSM(initialState: .locked, transitions: transitions)

        fsm.handle(event: .push)
        XCTAssertEqual(fsm.currentState, .locked) // Should stay locked
    }

    func testMultipleTransitions() {
         let transitions: [GraphFSM<State, Event>.Transition] = [
             .init(from: .locked, event: .coin, to: .unlocked),
             .init(from: .unlocked, event: .push, to: .locked)
         ]
         let fsm = GraphFSM(initialState: .locked, transitions: transitions)

         fsm.handle(event: .coin)
         XCTAssertEqual(fsm.currentState, .unlocked)

         fsm.handle(event: .push)
         XCTAssertEqual(fsm.currentState, .locked)
     }

    func testCallbacks() {
        let transitions: [GraphFSM<State, Event>.Transition] = [
            .init(from: .locked, event: .coin, to: .unlocked)
        ]
        let fsm = GraphFSM(initialState: .locked, transitions: transitions)

        var globalCallbackCalled = false
        var fromCallbackCalled = false
        var toCallbackCalled = false

        fsm.onTransition { transition in
            globalCallbackCalled = true
            XCTAssertEqual(transition.from, .locked)
            XCTAssertEqual(transition.to, .unlocked)
            XCTAssertEqual(transition.event, .coin)
        }

        fsm.onTransition(from: .locked) { transition in
            fromCallbackCalled = true
        }

        fsm.onTransition(to: .unlocked) { transition in
            toCallbackCalled = true
        }

        fsm.handle(event: .coin)

        XCTAssertTrue(globalCallbackCalled)
        XCTAssertTrue(fromCallbackCalled)
        XCTAssertTrue(toCallbackCalled)
    }

    func testCallbacksNotCalledOnInvalidTransition() {
        let transitions: [GraphFSM<State, Event>.Transition] = [
            .init(from: .locked, event: .coin, to: .unlocked)
        ]
        let fsm = GraphFSM(initialState: .locked, transitions: transitions)

        var callbackCalled = false
        fsm.onTransition { _ in callbackCalled = true }

        fsm.handle(event: .push) // Invalid

        XCTAssertFalse(callbackCalled)
    }

    func testGranularCallbacks() {
        let transitions: [GraphFSM<State, Event>.Transition] = [
            .init(from: .locked, event: .coin, to: .unlocked),
            .init(from: .unlocked, event: .push, to: .locked)
        ]
        let fsm = GraphFSM(initialState: .locked, transitions: transitions)

        var fromEventCallbackCalled = false
        var toEventCallbackCalled = false

        fsm.onTransition(from: .locked, on: .coin) { transition in
            fromEventCallbackCalled = true
            XCTAssertEqual(transition.from, .locked)
            XCTAssertEqual(transition.event, .coin)
        }

        fsm.onTransition(to: .unlocked, on: .coin) { transition in
            toEventCallbackCalled = true
            XCTAssertEqual(transition.to, .unlocked)
            XCTAssertEqual(transition.event, .coin)
        }

        // Trigger the transition
        fsm.handle(event: .coin)

        XCTAssertTrue(fromEventCallbackCalled)
        XCTAssertTrue(toEventCallbackCalled)
    }
}
