//
//  Coordinator.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/5/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine

protocol Coordinator: AnyObject {
    associatedtype CoordinatorStep: Step
    associatedtype ParentCoordinatorStep: Step
    
    /// Quick way to distinguish different instances of coordinators
    var identifier: String { get }
    
    /// Way to tell parent that we are done, and what action they should take
    var forwardToParent: AnyPublisher<ParentCoordinatorStep, Never> { get }
    
    /// Item that we are presenting
    var presentable: Presentable { get }
    
    /// Way for this coordinator to handle its own steps
    func handle(step: CoordinatorStep)
    
    /// Storage for the children
    var children: [String: Any] { get set }
    
    /// cancel bag
    var disposeBag: Set<AnyCancellable> { get set }
}

extension Coordinator {
    func addChild<T: Coordinator>(_ child: T) where T.ParentCoordinatorStep == Self.CoordinatorStep {
        let childId = child.identifier
        children[childId] = child
        
        child.forwardToParent
            .drop(untilOutputFrom: child.presentable.isVisible)
            .prefix(untilOutputFrom: child.presentable.isDismissed)
            .sink(receiveValue: { [weak self] step in
                self?.handle(step: step)
            })
            .store(in: &disposeBag)
        
        child.presentable
            .isDismissed
            .sink { [weak self] _ in
                self?.children[childId] = nil
            }
            .store(in: &disposeBag)
    }
}
