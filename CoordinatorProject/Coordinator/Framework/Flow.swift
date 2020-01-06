//
//  Flow.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine

protocol Flow: AnyObject {
    associatedtype Step
    associatedtype Result
    
    /// The thing that this flow is actually presented in
    var presentable: Presentable { get }
        
    /// mechanism for comunicating with the outside world, or parent flow, that we have completed
    var onCompletion: AnyPublisher<Result, Never> { get }
        
    /// Router, thing that is able to route to different screens based on the step provided
    /// - Parameter step: step that we encountered
    func handle(step: Step)
    
    /// Storage for the children
    var children: [AnyHashable: Any] { get set }
    
    /// cancel bag
    var disposeBag: Set<AnyCancellable> { get set }
}

extension Flow {
    func add<T: Flow>(flow: T, handler: ((T.Result) -> Void)? = nil)  {
        let childId = ObjectIdentifier(flow)
        children[childId] = flow
        
        flow.onCompletion
            .drop(untilOutputFrom: flow.presentable.isVisible)
            .prefix(untilOutputFrom: flow.presentable.isDismissed)
            .sink(receiveValue: { step in
                handler?(step)
            })
            .store(in: &disposeBag)
        
        flow.presentable
            .isDismissed
            .sink { [weak self] _ in
                self?.children[childId] = nil
            }
            .store(in: &disposeBag)
    }
    
    func add<T: Screen>(screen: T) where T.ParentStep == Self.Step {
        let childId = ObjectIdentifier(screen)
        children[childId] = screen
        
        screen.flowStep
            .drop(untilOutputFrom: screen.presentable.isVisible)
            .prefix(untilOutputFrom: screen.presentable.isDismissed)
            .sink(receiveValue: { [weak self] step in
                self?.handle(step: step)
            })
            .store(in: &disposeBag)
        
        screen.presentable
            .isDismissed
            .sink { [weak self] _ in
                self?.children[childId] = nil
            }
            .store(in: &disposeBag)
    }
}
