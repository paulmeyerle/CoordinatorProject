//
//  MockStepper.swift
//  CoordinatorProjectTests
//
//  Created by Paul Meyerle on 1/6/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
@testable import CoordinatorProject

final class MockStepper<T>: Stepper {
    let stepper = PassthroughSubject<T, Never>()
}
