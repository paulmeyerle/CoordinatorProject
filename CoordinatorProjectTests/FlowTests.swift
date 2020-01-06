//
//  FlowTests.swift
//  CoordinatorProjectTests
//
//  Created by Paul Meyerle on 1/6/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import XCTest
@testable import CoordinatorProject

class FlowTests: XCTestCase {

    // MARK: add(flow:)
    
    func test_addFlow_SHOULD_addChild() {
        let mockViewController = MockViewController()
        let mockPresentable = MockPresentable(viewController: mockViewController)
        let subFlow = MockFlow<Void, Void>(presentable: mockPresentable)
        let sut = MockFlow<Void, Void>()
        sut.add(flow: subFlow)
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertNotNil(sut.children[ObjectIdentifier(subFlow)])
    }
    
    func test_addFlow_SHOULD_removeChildAfterPresentableIsDismissed() {
        let mockViewController = MockViewController()
        let mockPresentable = MockPresentable(viewController: mockViewController)
        let subFlow = MockFlow<Void, Void>(presentable: mockPresentable)
        let sut = MockFlow<Void, Void>()
        sut.add(flow: subFlow)
        mockPresentable.isDismissedSubject.send(())
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertNil(sut.children[ObjectIdentifier(subFlow)])
    }
    
    func test_addFlow_SHOULD_triggerHandlerOnCompletionEvent_WHEN_isVisible() {
        let handlerCalled = expectation(description: #function)
        let mockViewController = MockViewController()
        let mockPresentable = MockPresentable(viewController: mockViewController)
        let subFlow = MockFlow<Void, Void>(presentable: mockPresentable)
        let sut = MockFlow<Void, Void>()
        sut.add(flow: subFlow) { event in
            handlerCalled.fulfill()
        }
        
        mockPresentable.isVisibleSubject.send(())
        subFlow.onCompletionSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_addFlow_SHOULD_not_triggerHandlerOnCompletionEvent_BEFORE_isVisible() {
        let handlerCalled = expectation(description: #function)
        handlerCalled.isInverted = true
        
        let mockViewController = MockViewController()
        let mockPresentable = MockPresentable(viewController: mockViewController)
        let subFlow = MockFlow<Void, Void>(presentable: mockPresentable)
        let sut = MockFlow<Void, Void>()
        sut.add(flow: subFlow) { event in
            handlerCalled.fulfill()
        }
        
        subFlow.onCompletionSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    func test_addFlow_SHOULD_not_triggerHandlerOnCompletionEvent_AFTER_isDismissed() {
        let handlerCalled = expectation(description: #function)
        handlerCalled.isInverted = true
        
        let mockViewController = MockViewController()
        let mockPresentable = MockPresentable(viewController: mockViewController)
        let subFlow = MockFlow<Void, Void>(presentable: mockPresentable)
        let sut = MockFlow<Void, Void>()
        sut.add(flow: subFlow) { event in
            handlerCalled.fulfill()
        }
        
        mockPresentable.isDismissedSubject.send(())
        subFlow.onCompletionSubject.send(())
        
        waitForExpectations(timeout: 0.1)
    }
    
    // MARK: add(screen:)
    
    func test_addScreen_SHOULD_addChild() {
        let sut = MockFlow<Void, Void>()
        let mockPresentable = MockPresentable()
        let mockStepper = MockStepper<Void>()
        let screen = MockScreen<Void, Void>(presentable: mockPresentable,
                                            stepper: mockStepper.eraseToAnyStepper())

        sut.add(screen: screen)
        XCTAssertEqual(sut.children.count, 1)
        XCTAssertNotNil(sut.children[ObjectIdentifier(screen)])
    }
    
    func test_addScreen_SHOULD_removeChildAfterPresentableIsDismissed() {
        let sut = MockFlow<Void, Void>()
        let mockPresentable = MockPresentable()
        let mockStepper = MockStepper<Void>()
        let screen = MockScreen<Void, Void>(presentable: mockPresentable,
                                            stepper: mockStepper.eraseToAnyStepper())

        sut.add(screen: screen)
        mockPresentable.isDismissedSubject.send(())
        XCTAssertEqual(sut.children.count, 0)
        XCTAssertNil(sut.children[ObjectIdentifier(screen)])
    }
    
    func test_addScreen_SHOULD_triggerHandlerOnCompletionEvent_WHEN_isVisible() {
        let sut = MockFlow<Int, Void>()
        let mockPresentable = MockPresentable()
        let mockStepper = MockStepper<Int>()
        let screen = MockScreen<Int, Int>(presentable: mockPresentable,
                                            stepper: mockStepper.eraseToAnyStepper())
        screen.mapToParentResult = 1

        sut.add(screen: screen)
        
        mockPresentable.isVisibleSubject.send(())
        mockStepper.stepper.send(1)
        mockStepper.stepper.send(2)
        mockStepper.stepper.send(3)
        
        XCTAssertEqual(sut.handleCallCount, 3)
        XCTAssertEqual(sut.handleParamStep, [1,1,1])
    }
    
    func test_addScreen_SHOULD_not_triggerHandlerOnCompletionEvent_BEFORE_isVisible() {
        let sut = MockFlow<Int, Void>()
        let mockPresentable = MockPresentable()
        let mockStepper = MockStepper<Int>()
        let screen = MockScreen<Int, Int>(presentable: mockPresentable,
                                            stepper: mockStepper.eraseToAnyStepper())
        screen.mapToParentResult = 1

        sut.add(screen: screen)
        
        mockStepper.stepper.send(1)
        mockStepper.stepper.send(2)
        mockStepper.stepper.send(3)
        
        XCTAssertEqual(sut.handleCallCount, 0)
    }
    
    func test_addScreen_SHOULD_not_triggerHandlerOnCompletionEvent_AFTER_isDismissed() {
        let sut = MockFlow<Int, Void>()
        let mockPresentable = MockPresentable()
        let mockStepper = MockStepper<Int>()
        let screen = MockScreen<Int, Int>(presentable: mockPresentable,
                                            stepper: mockStepper.eraseToAnyStepper())
        screen.mapToParentResult = 1

        sut.add(screen: screen)
        
        mockPresentable.isDismissedSubject.send(())
        mockStepper.stepper.send(1)
        mockStepper.stepper.send(2)
        mockStepper.stepper.send(3)
        
        XCTAssertEqual(sut.handleCallCount, 0)
    }

}
