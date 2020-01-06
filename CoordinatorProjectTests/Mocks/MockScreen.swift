//
//  MockScreen.swift
//  CoordinatorProjectTests
//
//  Created by Paul Meyerle on 1/6/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

@testable import CoordinatorProject

final class MockScreen<MockScreenStep, MockParentStep>: Screen {

    let presentable: Presentable
    
    let stepper: AnyStepper<MockScreenStep>
    
    init(presentable: Presentable = MockPresentable(), stepper: AnyStepper<MockScreenStep>) {
        self.presentable = presentable
        self.stepper = stepper
    }
    
    private(set) var mapToParentCallCount: Int = 0
    private(set) var mapToParentParamStep = [MockScreenStep]()
    var mapToParentResult: MockParentStep?
    func mapToParent(step: MockScreenStep) -> MockParentStep? {
        mapToParentCallCount += 1
        mapToParentParamStep.append(step)
        return mapToParentResult
    }
    
}
