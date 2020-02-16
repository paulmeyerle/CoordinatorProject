//
//  PresentableNavigationController.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import UIKit

final class PresentableNavigationController: UINavigationController, Presentable {
    private let isVisibleSubject = PassthroughSubject<Void, Never>()
    var isVisible: AnyPublisher<Void, Never> {
        isVisibleSubject.eraseToAnyPublisher()
    }
    
    private let isDismissedSubject = PassthroughSubject<Void, Never>()
    var isDismissed: AnyPublisher<Void, Never> {
        isDismissedSubject.eraseToAnyPublisher()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisibleSubject.send(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            isDismissedSubject.send(())
            isDismissedSubject.send(completion: .finished)
        }
    }
}
