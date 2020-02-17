//
//  EventEmitter.swift
//  CoordinatorProject
//
//  Created by Paul Meyerle on 1/4/20.
//  Copyright © 2020 Paul Meyerle. All rights reserved.
//

import Combine

protocol EventEmitter {
    associatedtype Event
    var eventPublisher: AnyPublisher<Event, Never> { get }
}
