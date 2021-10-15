//
//  Service.swift
//  Financial App
//
//  Created by administrator on 11.10.21.
//

import Foundation
import Dip
import RxSwift
import CoreData

extension DependencyContainer {
    static func configure() -> DependencyContainer {
        return DependencyContainer { container in
            unowned let container = container
            
            container.register(.unique) { APICalling() }
            container.register(.unique) { DisposeBag() }
            container.register(.unique) { [List]() }
            container.register(.unique) { [Favorite]() }
            container.register(.unique) { (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext }
            container.register(.unique) { [Lots]() }
            container.register(.unique) { APIRequest() }
            container.register(.unique) { [Result]() }
            
            container.register(.unique) { ViewControllerViewModel() }
                .resolvingProperties { container, service in
                    service.apiCalling = try! container.resolve()
                    service.disposeBag = try! container.resolve()
                    service.list = try! container.resolve()
                    service.favoriteList = try! container.resolve()
                    service.context = try! container.resolve()
                    service.request = try! container.resolve()
                }
            
            container.register(.unique) { UserAccountViewModel() }
                .resolvingProperties { container, service in
                    service.apiCalling = try! container.resolve()
                    service.context = try! container.resolve()
                    service.disposeBag = try! container.resolve()
                    service.lots = try! container.resolve()
                    service.request = try! container.resolve()
                }
            
            container.register(.unique) { SearchControllerViewModel() }
                .resolvingProperties { container, service in
                    service.apiCalling = try! container.resolve()
                    service.disposeBag = try! container.resolve()
                    service.request = try! container.resolve()
                    service.result = try! container.resolve()
                }
            
            container.register(.unique) { SectionViewModel() }
                .resolvingProperties { container, service in
                    service.context = try! container.resolve()
                    service.list = try! container.resolve()
                }
            
            container.register(.unique) { TickDetailViewModel() }
                .resolvingProperties { container, service in
                    service.apiCalling = try! container.resolve()
                    service.disposeBag = try! container.resolve()
                    service.lots = try! container.resolve()
                    service.request = try! container.resolve()
                    service.context = try! container.resolve()
                }
            
            container.register(tag: "ViewController") { ViewController() }
                .resolvingProperties { container, controller in
                    controller.viewModel = try! container.resolve()
                }
            
            container.register(tag: "SearchController") { SearchController() }
                .resolvingProperties { container, controller in
                    controller.viewModel = try! container.resolve()
                }
            
            container.register(tag: "TickDetail") { TickDetail() }
                .resolvingProperties { container, controller in
                    controller.viewModel = try! container.resolve()
                }
            
            container.register(tag: "UserAccount") { UserAccount() }
                .resolvingProperties { container, controller in
                    controller.viewModel = try! container.resolve()
                }
            
            container.register(tag: "ListOfSection") { ListOfSection() }
                .resolvingProperties { container, controller in
                    controller.viewModel = try! container.resolve()
                }
            
            DependencyContainer.uiContainers = [container]
        }
    }
}



