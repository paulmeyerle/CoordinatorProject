//
//  Stepper.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine

protocol Stepper {
    associatedtype StepperStep: Step
    var stepper: PassthroughSubject<StepperStep, Never> { get }
}

extension Stepper {
    func eraseToAnyStepper() -> AnyStepper<StepperStep> {
        return AnyStepper(self)
    }
}

final class AnyStepper<T: Step>: Stepper {
    private let _stepper: PassthroughSubject<T, Never>
    
    var stepper: PassthroughSubject<T, Never> {
        _stepper
    }
    
    init<U: Stepper>(_ steppable: U) where U.StepperStep == T {
        _stepper = steppable.stepper
    }
}
