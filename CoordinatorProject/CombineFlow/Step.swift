//
//  Screen.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import UIKit


/// The `Step` is responsible for coupling a View/ViewModel or a sub `Flow` to a parent `Flow`.
/// You can think of these as a `Step` in the `Flow`
///
/// This allows us to convert events emitted from the `Step` into something that the `Parent` can understand
/// without directly coupling them allowing us to re-use Screens and Flows in multiple Flows.  Steps should be specific
/// to the parent/child and should not be reused.
public protocol Step: AnyObject {
    associatedtype Event
    associatedtype ParentEvent
    
    /// Item which should be presented
    var rootViewController: UIViewController & Presentable { get }
    
    /// Lifecycle of the step.  When wrapping a flow, this should be the flow itself.  When wrapping a screen this should be the rootViewController.
    var presentable: Presentable { get }
    
    /// These are the events emitted from the embedded screen/flow.
    var eventPublisher: AnyPublisher<Event, Never> {  get }
    
    /// These are the `eventPublisher` events after they have passed through the `mapToParent(event:)` function.
    /// These are now events that the parent should be able to understand and action on.
    var parentEventPublisher: AnyPublisher<ParentEvent, Never> { get }
        
    /// Converts steps emited from the screen/flow into something that the parent can understand
    /// - Parameter event: event, usually events emitted from a view model or a sub-flow's result
    func mapToParent(event: Event) -> ParentEvent?
    
    /// Cancel bag for Combine chains
    var cancellables: Set<AnyCancellable> { get set }
}

public extension Step {
    // Default implementation:  You should not have to override this.
    // Converts the screen/sub-flow `Event` into the `ParentEvent`
    // using the provided `mapToParent(event:)` method.
    var parentEventPublisher: AnyPublisher<ParentEvent, Never> {
        eventPublisher
            .compactMap { [weak self] step in
                self?.mapToParent(event: step)
            }
            .eraseToAnyPublisher()
    }
}

public extension Step where ParentEvent == Void {
    
    /// Typically, when the `ParentEvent` is `Void` we are purposfully ignoring them.
    /// This is a handy default implementation which does nothing in this case.
    func mapToParent(event: Event) -> Void? { return nil }
}

public extension Step where Event == Void {
    
    /// Typically, when the `Event` is `Void` we are purposfully ignoring them.
    /// This is a handy default implementation which does nothing in this case.
    func mapToParent(event: Void) -> ParentEvent? { return nil }
    
    /// Typically, when the `Event` type is `Void` the `Step` won't be sending out any events.
    /// This is a handy default implementation for that case.  If you intentionally have a `Void` event type
    /// and want to send those then just  implement `eventPublisher` in your `Step`.
    var eventPublisher: AnyPublisher<Void, Never> {
        Empty().eraseToAnyPublisher()
    }
}

public extension Step where Event == Void, ParentEvent == Void {
    /// Typically, when the `Event` is `Void` we are purposfully ignoring them.
    /// This is a handy default implementation which does nothing in this case.
    func mapToParent(event: Void) -> Void? { return nil }
    
    /// Typically, when the `Event` type is `Void` the `Step` won't be sending out any events.
    /// This is a handy default implementation for that case.  If you intentionally have a `Void` event type
    /// and want to send those then just  implement `eventPublisher` in your `Step`.
    var eventPublisher: AnyPublisher<Void, Never> {
        Empty().eraseToAnyPublisher()
    }
}

public extension Step where Event == Never {
    /// Typically, when the `Event` is `Never` we are purposfully ignoring them.
    /// This is a handy default implementation which does nothing in this case.
    func mapToParent(event: Never) -> ParentEvent? {}
}
