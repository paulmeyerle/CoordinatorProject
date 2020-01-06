//
//  Presentable.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import UIKit.UIViewController
import Combine

protocol Presentable {
    var isVisible: AnyPublisher<Void, Never> { get }
    var isDismissed: AnyPublisher<Void, Never> { get }
    var viewController: UIViewController { get }
}
