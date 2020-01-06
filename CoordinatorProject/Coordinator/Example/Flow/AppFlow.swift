//
//  AppFlow.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import UIKit

enum AppFlowStates: Step {
    case home
    case homeCompleted
}

enum AppFlowResult: FlowResult {
    case completed
}

final class AppFlow: Flow {
    private let window: UIWindow
    
    var disposeBag = Set<AnyCancellable>()
    
    let identifier: String = UUID().uuidString
    
    var presentable: Presentable {
        navigationController
    }
    
    private let navigationController = PresentableNavigationController()
    
    let onCompletion: AnyPublisher<AppFlowResult, Never> = Empty().eraseToAnyPublisher()
    
    var children = [String: Any]()
    
    init(window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        handle(step: .home)
    }
    
    func handle(step: AppFlowStates) {
        switch step {
        case .home:
            let child = HomeFlow()
            add(flow: child) { [weak self] result in
                guard case .completed = result else { return }
                self?.handle(step: .homeCompleted)
            }
            navigationController.present(child.presentable.viewController, animated: true)
        case .homeCompleted:
            navigationController.dismiss(animated: true)
        }
    }
}
