//
//  MainCoordinator.swift
//  Financial App
//
//  Created by administrator on 20.09.21.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func finhubDetail(ticker : String) {
        let vc = TickDetail.instantiate()
        vc.ticker = ticker
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func userAccount() {
        let vc = UserAccount.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func searchController() {
        let vc = SearchController.instantiate()
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }
    
}
