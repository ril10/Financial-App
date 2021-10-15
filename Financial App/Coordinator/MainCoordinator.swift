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
    
    func finhubDetail(ticker : String,from : Int, to : Int) {
        let vc = TickDetail.instantiate()
        vc.viewModel.companyData(symbol: ticker)
        vc.viewModel.priceQuote(symbol: ticker)
        vc.viewModel.requestStockHandleData(symbol: ticker, from: from, to: to)
        vc.viewModel.symbol = ticker
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
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
    
    func listController(symbol : String, companyName : String, currentPrice : String) {
        let vc = ListOfSection.instantiate()
//        vc.viewModel.symbol = symbol
//        vc.viewModel.companyName = companyName
//        vc.viewModel.currentPrice = currentPrice
        vc.symbol = symbol
        vc.companyName = companyName
        vc.currentPrice = currentPrice
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}
