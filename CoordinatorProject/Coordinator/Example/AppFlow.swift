//
//  AppFlow.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import UIKit

enum AppFlowStep {
    case home
    case homeCompleted
}

enum AppFlowResult {
    case completed
}

final class AppFlow: Flow {
    private let window: UIWindow
    
    var disposeBag = Set<AnyCancellable>()
    
    var presentable: Presentable {
        navigationController
    }
    
    private let navigationController = PresentableNavigationController()
    
    let onCompletion: AnyPublisher<AppFlowResult, Never> = Empty().eraseToAnyPublisher()
    
    var children = [AnyHashable: Any]()
    
    init(window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        handle(step: .home)
    }
    
    func handle(step: AppFlowStep) {
        switch step {
        case .home:
            let child = HomeFlow()
            add(flow: child) { [weak self] result in
                // TODO: it would be nice to be able to move this code into a more testable bit.  Kind of like the `Screen` Concept....
                // maybe the screen concept could be make more generic, or we could have another protocol for what this encapsulation is.
                guard case .completed = result else { return }
                self?.handle(step: .homeCompleted)
            }
            navigationController.present(child.presentable.viewController, animated: true)
        case .homeCompleted:
            navigationController.dismiss(animated: true)
        }
    }
}
