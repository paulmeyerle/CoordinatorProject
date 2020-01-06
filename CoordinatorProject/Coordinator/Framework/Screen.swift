//
//  Screen.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine

protocol Screen: AnyObject {
    associatedtype ScreenStep: Step
    associatedtype ParentStep: Step

    var identifier: String { get }
    
    var presentable: Presentable { get }
    
    var stepper: AnyStepper<ScreenStep> { get }
    
    func mapToParent(step: ScreenStep) -> ParentStep?
        
    /// Terrible name, but this is how we communicate to the parent flow what action we need to take base on what our screen told it to do
    var flowStep: AnyPublisher<ParentStep, Never> { get }
}

extension Screen {
    var flowStep: AnyPublisher<ParentStep, Never> {
        stepper.stepper
            .compactMap { [weak self] step in
                self?.mapToParent(step: step)
            }
            .eraseToAnyPublisher()
    }
}
