////
////  ScreenTests.swift
////  CoordinatorProjectTests
////
////  Created by Paul Meyerle on 1/6/20.
////  Copyright © 2020 Paul Meyerle. All rights reserved.
////
//
//import XCTest
//import Combine
//@testable import CoordinatorProject
//
//class ScreenTests: XCTestCase {
//    
//    // MARK: flowStep
//    
//    func test_flowStep_SHOULD_triggerMapToParent_WHEN_nonNilMapToParentResponse() {
//        var disposeBag = Set<AnyCancellable>()
//        let mockStepper = MockStepper<Int>()
//        let sut = MockScreen<Int, Int>(stepper: mockStepper.eraseToAnyStepper())
//        sut.mapToParentResult = 999
//        
//        var elements = [Int]()
//        sut.flowStep
//            .sink(receiveValue: { step in
//                elements.append(step)
//            })
//            .store(in: &disposeBag)
//        
//        mockStepper.stepper.send(1)
//        mockStepper.stepper.send(2)
//        
//        XCTAssertEqual(sut.mapToParentCallCount, 2)
//        XCTAssertEqual(sut.mapToParentParamStep, [1, 2])
//        XCTAssertEqual(elements, [999, 999])
//    }
//    
//    func test_flowStep_SHOULD_triggerMapToParent_WHEN_nilMapToParentResponse() {
//        var disposeBag = Set<AnyCancellable>()
//        let mockStepper = MockStepper<Int>()
//        let sut = MockScreen<Int, Int>(stepper: mockStepper.eraseToAnyStepper())
//        sut.mapToParentResult = nil
//        
//        var elements = [Int]()
//        sut.flowStep
//            .sink(receiveValue: { step in
//                elements.append(step)
//            })
//            .store(in: &disposeBag)
//        
//        mockStepper.stepper.send(1)
//        mockStepper.stepper.send(2)
//        
//        XCTAssertEqual(sut.mapToParentCallCount, 2)
//        XCTAssertEqual(sut.mapToParentParamStep, [1, 2])
//        XCTAssertEqual(elements, [])
//    }
//    
//}
