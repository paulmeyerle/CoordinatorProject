//
//  AppCoordinator.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/5/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import UIKit

enum AppCoordinatorStep: Step {
    case home
    case homeCompleted
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    var disposeBag = Set<AnyCancellable>()
    
    let identifier: String = UUID().uuidString
    
    var presentable: Presentable {
        navigationController
    }
    
    var children = [String: Any]()
    
    private let navigationController = PresentableNavigationController()
    
    // We are at the root, so no parent to forward events to
    var forwardToParent: AnyPublisher<AppCoordinatorStep, Never> = Empty().eraseToAnyPublisher()
    
    init(window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        handle(step: .home)
    }
    
    func handle(step: AppCoordinatorStep) {
        switch step {
        case .home:
            let child = HomeCoordinator()
            addChild(child)
            navigationController.present(child.presentable.viewController, animated: true)
        case .homeCompleted:
            navigationController.dismiss(animated: true)
        }
    }
}
