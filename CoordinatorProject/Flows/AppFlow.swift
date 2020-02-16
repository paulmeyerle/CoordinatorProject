//
//  AppFlow.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine
import UIKit

enum AppFlowEvent {
    case home
    case homeCompleted
}

final class AppFlow: Flow {
    private let window: UIWindow
    private let navigationController = PresentableNavigationController()
    
    var rootViewController: UIViewController & Presentable {
        navigationController
    }
    
    var stepStore = StepStore()
    
    init(window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        handle(event: .home)
    }
    
    func handle(event: AppFlowEvent) {
        switch event {
        case .home:
            let screen = HomeFlowScreen()
            add(step: screen)
            navigationController.present(screen.rootViewController, animated: true)
        case .homeCompleted:
            navigationController.dismiss(animated: true)
        }
    }
    
    final class HomeFlowScreen: Step {
        typealias ParentEvent = AppFlowEvent
        
        private let flow: HomeFlow
        
        var cancellables = Set<AnyCancellable>()
        
        var rootViewController: UIViewController & Presentable {
            flow.rootViewController
        }
        
        var presentable: Presentable {
            rootViewController
        }
        
        init(flow: HomeFlow = HomeFlow()) {
            self.flow = flow
            print("HomeScreen - init")
        }
        
        deinit {
            print("HomeScreen - deinit")
        }
    }
}
