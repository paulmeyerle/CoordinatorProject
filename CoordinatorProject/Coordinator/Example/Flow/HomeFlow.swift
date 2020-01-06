//
//  HomeFlow.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/5/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import UIKit
import Combine

enum HomeFlowStep: Step {
    case screen1
    case screen2
    case screen3
    case completed
}

enum HomeFlowResult: FlowResult {
    case completed
}

final class HomeFlow: Flow {
    private let onCompletionSubject = PassthroughSubject<HomeFlowResult, Never>()
    lazy var onCompletion: AnyPublisher<HomeFlowResult, Never> = {
        onCompletionSubject
            .eraseToAnyPublisher()
    }()
    
    var disposeBag = Set<AnyCancellable>()

    let identifier: String = UUID().uuidString
    
    var presentable: Presentable {
        navigationController
    }
    
    private let navigationController: PresentableNavigationController = {
        let controller = PresentableNavigationController()
        controller.modalPresentationStyle = .fullScreen
        return controller
    }()
    
    init() {
        handle(step: .screen1)
        
        print("HomeFlow - init")
    }
    
    deinit {
        print("HomeFlow - deinit")
    }
    
    var children = [String: Any]()

    func handle(step: HomeFlowStep) {
        switch step {
        case .screen1:
            let child = Screen1()
            add(screen: child)
            navigationController.pushViewController(child.presentable.viewController, animated: true)
        case .screen2:
            let child = Screen2()
            add(screen: child)
            navigationController.pushViewController(child.presentable.viewController, animated: true)
        case .screen3:
            let child = Screen3()
            add(screen: child)
            navigationController.pushViewController(child.presentable.viewController, animated: true)
        case .completed:
            onCompletionSubject.send(.completed)
            onCompletionSubject.send(completion: .finished)
        }
    }
    
    final class Screen1: Screen {
        let identifier: String = UUID().uuidString
        
        lazy var stepper: AnyStepper<ContentViewStep> = {
            viewModel.eraseToAnyStepper()
        }()
        
        private let viewModel: ContentViewModel = {
            ContentViewModel(screenNumber: 1)
        }()
        
        lazy var presentable: Presentable = {
            let view = ContentView(viewModel: viewModel)
            return PresentableHostingController(rootView: view)
        }()
        
        init() {
            print("Screen1 - init")
        }
        
        deinit {
            print("Screen1 - deinit")
        }
        
        func mapToParent(step: ContentViewStep) -> HomeFlowStep? {
            switch step {
            case .nextIsPicked:
                return .screen2
            }
        }
    }
    
    final class Screen2: Screen {
        let identifier: String = UUID().uuidString
        
        lazy var stepper: AnyStepper<ContentViewStep> = {
            viewModel.eraseToAnyStepper()
        }()
        
        private let viewModel: ContentViewModel = {
            ContentViewModel(screenNumber: 2)
        }()
        
        lazy var presentable: Presentable = {
            let view = ContentView(viewModel: viewModel)
            return PresentableHostingController(rootView: view)
        }()
        
        init() {
            print("Screen2 - init")
        }
        
        deinit {
            print("Screen2 - deinit")
        }
        
        func mapToParent(step: ContentViewStep) -> HomeFlowStep? {
            switch step {
               case .nextIsPicked:
                   return .screen3
            }
        }
    }
    
    final class Screen3: Screen {
        let identifier: String = UUID().uuidString
        
        lazy var stepper: AnyStepper<ContentViewStep> = {
            viewModel.eraseToAnyStepper()
        }()
        
        private let viewModel: ContentViewModel = {
            ContentViewModel(screenNumber: 3)
        }()
        
        lazy var presentable: Presentable = {
            let view = ContentView(viewModel: viewModel)
            return PresentableHostingController(rootView: view)
        }()
        
        init() {
            print("Screen3 - init")
        }
        
        deinit {
            print("Screen3 - deinit")
        }
        
        func mapToParent(step: ContentViewStep) -> HomeFlowStep? {
            switch step {
            case .nextIsPicked:
                return .completed
            }
        }
    }
}
