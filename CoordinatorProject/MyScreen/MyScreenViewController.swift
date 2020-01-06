//
//  MyScreenViewController.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import UIKit
import Combine

final class MyScreenViewController : UIViewController, Presentable {
    private let isVisibleSubject = PassthroughSubject<Void, Never>()
    var isVisible: AnyPublisher<Void, Never> {
        isVisibleSubject.eraseToAnyPublisher()
    }
    
    private let isDismissedSubject = PassthroughSubject<Void, Never>()
    var isDismissed: AnyPublisher<Void, Never> {
        isDismissedSubject.eraseToAnyPublisher()
    }
    
    var viewController: UIViewController {
        return self
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
    
    private let viewModel: MyScreenViewModel
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("next", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    init(viewModel: MyScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
         print("MyScreenViewController - init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("MyScreenViewController - deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    @objc private func onButtonTap() {
        viewModel.onButtonTap()
    }
    
    private func setupBindings() {
        label.text = viewModel.titleText
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
