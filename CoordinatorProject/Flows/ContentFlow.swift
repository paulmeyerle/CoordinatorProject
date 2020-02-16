//
//  ContentFlow.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 2/15/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import UIKit
import Combine

enum ContentFlowEvent {
    case screen1
    case screen2
    case screen3
    case completed
}

enum ContentFlowResult {
    case completed
}

final class ContentFlow: Flow {
    
    private let resultSubject = PassthroughSubject<ContentFlowResult, Never>()
    var resultPublisher: AnyPublisher<ContentFlowResult, Never> {
        resultSubject.eraseToAnyPublisher()
    }

    var rootViewController: UIViewController & Presentable {
        navigationController
    }
    
    private let navigationController: UINavigationController & Presentable
    
    init(rootViewController: UINavigationController & Presentable = PresentableNavigationController()) {
        self.navigationController = rootViewController
        
        handle(event: .screen1)
        print("ContentFlow - init")
    }
    
    deinit {
        print("ContentFlow - deinit")
    }
    
    var stepStore = StepStore()

    func handle(event: ContentFlowEvent) {
        switch event {
        case .screen1:
            let child = Screen1()
            add(step: child)
            navigationController.pushViewController(child.rootViewController, animated: true)
        case .screen2:
            let child = Screen2()
            add(step: child)
            navigationController.pushViewController(child.rootViewController, animated: true)
        case .screen3:
            let child = Screen3()
            add(step: child)
            navigationController.pushViewController(child.rootViewController, animated: true)
        case .completed:
            resultSubject.send(.completed)
            resultSubject.send(completion: .finished)
        }
    }
    
    final class Screen1: Step {
        var cancellables = Set<AnyCancellable>()
        
        lazy var eventPublisher: AnyPublisher<ContentViewModelFlowEvent, Never> = {
            viewModel.stepper.eraseToAnyPublisher()
        }()
        
        private let viewModel: ContentViewModel = {
            ContentViewModel(title: "ContentFlow", screenNumber: 1)
        }()
        
        lazy var rootViewController: UIViewController & Presentable = {
            let view = ContentView(viewModel: viewModel)
            return PresentableHostingController(rootView: view)
        }()
        
        var presentable: Presentable {
            rootViewController
        }
        
        init() {
            print("ContentFlow - Screen1 - init")
        }
        
        deinit {
            print("ContentFlow - Screen1 - deinit")
        }
        
        func mapToParent(event: ContentViewModelFlowEvent) -> ContentFlowEvent? {
            switch event {
            case .nextIsPicked:
                return .screen2
            }
        }
    }
    
    final class Screen2: Step {
        var cancellables = Set<AnyCancellable>()
        
        lazy var eventPublisher: AnyPublisher<ContentViewModelFlowEvent, Never> = {
            viewModel.stepper.eraseToAnyPublisher()
        }()
        
        private let viewModel: ContentViewModel = {
            ContentViewModel(title: "ContentFlow", screenNumber: 2)
        }()
        
        lazy var rootViewController: UIViewController & Presentable = {
            let view = ContentView(viewModel: viewModel)
            return PresentableHostingController(rootView: view)
        }()
        
        var presentable: Presentable {
            rootViewController
        }
        
        init() {
            print("ContentFlow - Screen2 - init")
        }
        
        deinit {
            print("ContentFlow - Screen2 - deinit")
        }
        
        func mapToParent(event: ContentViewModelFlowEvent) -> ContentFlowEvent? {
            switch event {
               case .nextIsPicked:
                   return .screen3
            }
        }
    }
    
    final class Screen3: Step {
        var cancellables = Set<AnyCancellable>()
        
        lazy var eventPublisher: AnyPublisher<ContentViewModelFlowEvent, Never> = {
            viewModel.stepper.eraseToAnyPublisher()
        }()
        
        private let viewModel: ContentViewModel = {
            ContentViewModel(title: "ContentFlow", screenNumber: 3)
        }()
        
        lazy var rootViewController: UIViewController & Presentable = {
            let view = ContentView(viewModel: viewModel)
            return PresentableHostingController(rootView: view)
        }()
        
        var presentable: Presentable {
            rootViewController
        }

        init() {
            print("ContentFlow - Screen3 - init")
        }
        
        deinit {
            print("ContentFlow - Screen3 - deinit")
        }
        
        func mapToParent(event: ContentViewModelFlowEvent) -> ContentFlowEvent? {
            return .completed
        }
    }
}
