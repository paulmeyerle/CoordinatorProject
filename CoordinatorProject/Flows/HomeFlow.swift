//
//  HomeFlow.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/5/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import UIKit
import Combine

enum HomeFlowEvent {
    case home
    case presentFlow
    case presentFlowIsComplete
    case pushFlow
    case optionList(handler: (_ id: Int, _ name: String) -> Void)
    case optionListIsComplete
}

final class HomeFlow: Flow {
    var rootViewController: UIViewController & Presentable {
        navigationController
    }
    
    private let navigationController: PresentableNavigationController = {
        let controller = PresentableNavigationController()
        controller.modalPresentationStyle = .fullScreen
        return controller
    }()
    
    init() {
        handle(event: .home)
        
        print("HomeFlow - init")
    }
    
    deinit {
        print("HomeFlow - deinit")
    }
    
    var stepStore = StepStore()

    func handle(event: HomeFlowEvent) {
        switch event {
        case .home:
            let step = HomeStep()
            add(step: step)
            navigationController.pushViewController(step.rootViewController, animated: true)
        case .pushFlow:
            let flow = ContentFlow(rootViewController: navigationController)
            let step = SubFlowStep(flow: flow)
            add(step: step)
        case .presentFlow:
            let flow = ContentFlow()
            let step = SubFlowStep(flow: flow)
            add(step: step)
            navigationController.present(step.rootViewController, animated: true)
        case .presentFlowIsComplete:
            navigationController.dismiss(animated: true)
        case let .optionList(handler):
            let step = OptionListStep(handler: handler)
            add(step: step)
            navigationController.present(step.rootViewController, animated: true)
        case .optionListIsComplete:
            navigationController.dismiss(animated: true)
        }
    }
    
    final class SubFlowStep: Step {
        private let flow: ContentFlow
        
        var rootViewController: UIViewController & Presentable {
            flow.rootViewController
        }
        
        var presentable: Presentable {
            flow
        }
        
        var eventPublisher: AnyPublisher<ContentFlowResult, Never> {
            flow.resultPublisher
        }
        
        var cancellables = Set<AnyCancellable>()
        
        init(flow: ContentFlow) {
            self.flow = flow
        }
        
        func mapToParent(event: ContentFlowResult) -> HomeFlowEvent? {
            guard case .completed = event else { return nil }
            return .presentFlowIsComplete
        }
    }
    
    final class HomeStep: Step {
        var cancellables = Set<AnyCancellable>()
        
        var eventPublisher: AnyPublisher<HomeViewModelFlowEvent, Never> {
            viewModel.eventPublisher
        }
        
        private let viewModel: HomeViewModel = {
            HomeViewModel()
        }()
        
        lazy var rootViewController: UIViewController & Presentable = {
            let view = HomeView(viewModel: viewModel)
            return PresentableHostingController(rootView: view)
        }()
        
        var presentable: Presentable {
            rootViewController
        }
    
        init() {
            print("Screen1 - init")
        }
        
        deinit {
            print("Screen1 - deinit")
        }
        
        func mapToParent(event: HomeViewModelFlowEvent) -> HomeFlowEvent? {
            switch event {
            case .presentIsPicked:
                return .presentFlow
            case .pushIsPicked:
                return .pushFlow
            case let .optionIsRequired(handler):
                return .optionList(handler: handler)
            }
        }
    }
    
    final class OptionListStep: Step {
        private let viewModel = TypeaheadViewModel()
        
        lazy var rootViewController: UIViewController & Presentable = {
            let view = TypeaheadView(viewModel: viewModel)
            return PresentableHostingController(rootView: view)
        }()
        
        var presentable: Presentable {
            rootViewController
        }
        
        var eventPublisher: AnyPublisher<TypeaheadViewModelFlowEvent, Never> {
            viewModel.eventPublisher
        }
        
        var cancellables = Set<AnyCancellable>()
        
        private let handler: (_ id: Int, _ name: String) -> Void
        
        init(handler: @escaping (_ id: Int, _ name: String) -> Void) {
            self.handler = handler
        }
        
        func mapToParent(event: TypeaheadViewModelFlowEvent) -> HomeFlowEvent? {
            switch event {
            case .optionPicked(let id, let name):
                handler(id, name)
                return .optionListIsComplete
            }
        }
    }
}
