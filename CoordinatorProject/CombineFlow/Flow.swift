//
//  Flow.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import UIKit

/// A `Flow` defines a navigation area in your application.  This is the place where you declare the navigation actions
/// (such as presenting a UIViewController or another Flow).
/// Typically a flow will contain either a `UINavigationController`, `UIPageViewConntroller`, or `UITabBarController`.
///
/// `Flow`s  use `Step`s as a mechanism for hooking up a Screen or Sub-Flow.
public protocol Flow: AnyObject, Presentable {
    associatedtype Event
    associatedtype Result
    
    /// The object that this flow is presenting.  Typically a `UINavigationController`, `UIPageViewConntroller`, or `UITabBarController`.
    var rootViewController: UIViewController & Presentable { get }
        
    /// Mechanism for comunicating with our parent.  Every flow has the ability to emit `Result` events which should be handled by it's parent.
    var resultPublisher: AnyPublisher<Result, Never> { get }
        
    /// Event handler which for this `Flow`s event options.  This is typically where you would push/present/dismiss.
    /// - Parameter event: event that we received
    func handle(event: Event)
    
    /// Storage for  child `Step`s.  This allows them to be retained in memory while they are active.
    var stepStore: StepStore { get set }
}

// MARK: Presentable

public extension Flow  {
    var isVisible: AnyPublisher<Void, Never> {
        rootViewController.isVisible
    }
    
    var isDismissed: AnyPublisher<Void, Never> {
        Publishers.Merge(rootViewController.isDismissed, stepStore.isEmptyPublisher)
            .eraseToAnyPublisher()
    }
}

// MARK: Default Implementations

public extension Flow {
    /// Add a child step to this flow.  This will add the step to the `children` map as well as set up event sinks to trigger the `handle(event:)`
    /// method when the step's `parentEventPublisher` emits values.  The child will automatically be removed from the `children` map
    /// when its `Presentable` has been dismissed.
    ///
    /// - Parameter step: Child step we would like to add to the flow.
    func add<T: Step>(step: T) where T.ParentEvent == Self.Event {
        let childId = ObjectIdentifier(step)
        stepStore[childId] = step
        
        step.parentEventPublisher
            .drop(untilOutputFrom: step.presentable.isVisible)
            .prefix(untilOutputFrom: step.presentable.isDismissed)
            .sink(receiveValue: { [weak self] step in
                self?.handle(event: step)
            })
            .store(in: &step.cancellables)
        
        step.presentable.isDismissed
            .sink { [weak self] _ in
                self?.stepStore[childId] = nil
            }
            .store(in: &step.cancellables)
    }
}

public extension Flow where Event == Void {
    
    /// Typically, when the `Event` is `Void` we are purposfully ignoring them.
    /// This is a handy default implementation which does nothing in this case.
    func handle(event: Void) {}
}

public extension Flow where Result == Void {
    
    /// Typically, when the `Result` type is `Void` the `Flow` won't be sending out any events.
    /// This is a handy default implementation for that case.  If you intentionally have a `Void` resultt type
    /// and want to send those then just  implement `resultPublisher` in your `Flow`.
    var resultPublisher: AnyPublisher<Void, Never> {
        Empty().eraseToAnyPublisher()
    }
}
