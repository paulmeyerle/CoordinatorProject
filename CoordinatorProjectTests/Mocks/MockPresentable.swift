//
//  MockPresentable.swift
//  CoordinatorProjectTests
//
//  Created by Paul Meyerle on 1/6/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import UIKit
@testable import CoordinatorProject

//final class MockPresentable: Presentable {
//    var isVisibleSubject = PassthroughSubject<Void, Never>()
//    var isVisible: AnyPublisher<Void, Never> {
//        isVisibleSubject.eraseToAnyPublisher()
//    }
//    
//    var isDismissedSubject = PassthroughSubject<Void, Never>()
//    var isDismissed: AnyPublisher<Void, Never> {
//        isDismissedSubject.eraseToAnyPublisher()
//    }
//    
//    let viewController: UIViewController
//    
//    init(viewController: UIViewController = MockViewController()) {
//        self.viewController = viewController
//    }
//}
