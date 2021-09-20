//
//  Coordinator.swift
//  Financial App
//
//  Created by administrator on 20.09.21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    func start()
}
