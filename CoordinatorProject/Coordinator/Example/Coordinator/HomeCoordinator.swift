//
//  HomeCoordinator.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/5/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import UIKit
import Combine

enum HomeCoordinatorStep: Step {
    case screen1
    case screen2
    case screen3
    case completed
}

final class HomeCoordinator: Coordinator {
    private let forwardToParentSubject = PassthroughSubject<AppCoordinatorStep, Never>()
    lazy var forwardToParent: AnyPublisher<AppCoordinatorStep, Never> = {
        forwardToParentSubject
            .eraseToAnyPublisher()
    }()
    
    var disposeBag = Set<AnyCancellable>()

    let identifier: String = UUID().uuidString
    
    var presentable: Presentable {
        navigationController
    }
    
    private let navigationController = PresentableNavigationController()
    
    var children = [String: Any]()
    
    init() {
        handle(step: .screen1)
        
        print("HomeFlow - init")
    }
    
    deinit {
        print("HomeFlow - deinit")
    }

    func handle(step: HomeCoordinatorStep) {
        switch step {
        case .screen1:
            let child = Screen1()
            addChild(child)
            navigationController.pushViewController(child.presentable.viewController, animated: true)
        case .screen2:
            let child = Screen2()
            addChild(child)
            navigationController.pushViewController(child.presentable.viewController, animated: true)
        case .screen3:
            let child = Screen3()
            addChild(child)
            navigationController.pushViewController(child.presentable.viewController, animated: true)
        case .completed:
            forwardToParentSubject.send(.homeCompleted)
            forwardToParentSubject.send(completion: .finished)
        }
    }
    
    final class Screen1: Coordinator {
        lazy var forwardToParent: AnyPublisher<HomeCoordinatorStep, Never> = {
            viewModel.stepper
                .compactMap { step -> HomeCoordinatorStep in
                    switch step {
                    case .nextIsPicked:
                        return .screen2
                    }
            }
            .eraseToAnyPublisher()
        }()
        
        func handle(step: MyScreenViewEvent) {}
        
        let identifier: String = UUID().uuidString
        
        var children = [String : Any]()
        
        var disposeBag = Set<AnyCancellable>()
            
        private let viewModel: MyScreenViewModel = {
            MyScreenViewModel(screenNumber: 1)
        }()
        
        lazy var presentable: Presentable = {
            MyScreenViewController(viewModel: viewModel)
        }()
        
        init() {
            print("Screen1 - init")
        }
        
        deinit {
            print("Screen1 - deinit")
        }
    }
    
    final class Screen2: Coordinator {
        lazy var forwardToParent: AnyPublisher<HomeCoordinatorStep, Never> = {
            viewModel.stepper
                .compactMap { step -> HomeCoordinatorStep in
                    switch step {
                    case .nextIsPicked:
                        return .screen3
                    }
            }
            .eraseToAnyPublisher()
        }()
        
        func handle(step: MyScreenViewEvent) {}
        
        let identifier: String = UUID().uuidString
        
        var children = [String : Any]()
        
        var disposeBag = Set<AnyCancellable>()
            
        private let viewModel: MyScreenViewModel = {
            MyScreenViewModel(screenNumber: 2)
        }()
        
        lazy var presentable: Presentable = {
            MyScreenViewController(viewModel: viewModel)
        }()
        
        init() {
            print("Screen2 - init")
        }
        
        deinit {
            print("Screen2 - deinit")
        }
    }
    
    final class Screen3: Coordinator {
        lazy var forwardToParent: AnyPublisher<HomeCoordinatorStep, Never> = {
            viewModel.stepper
                .compactMap { step -> HomeCoordinatorStep in
                    switch step {
                    case .nextIsPicked:
                        return .completed
                    }
            }
            .eraseToAnyPublisher()
        }()
        
        func handle(step: MyScreenViewEvent) {
            // NOOP
        }
        
        let identifier: String = UUID().uuidString
        
        var children = [String : Any]()
        
        var disposeBag = Set<AnyCancellable>()
            
        private let viewModel: MyScreenViewModel = {
            MyScreenViewModel(screenNumber: 3)
        }()
        
        lazy var presentable: Presentable = {
            MyScreenViewController(viewModel: viewModel)
        }()
        
        init() {
            print("Screen3 - init")
        }
        
        deinit {
            print("Screen3 - deinit")
        }
    }
}
