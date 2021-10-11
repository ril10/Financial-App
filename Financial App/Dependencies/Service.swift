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
            
            container.register(tag: "ViewController") { ViewController() }
                .resolvingProperties { container, controller in
                    controller.apiCalling = try! container.resolve()
                    controller.disposeBag = try! container.resolve()
                    controller.list = try! container.resolve()
                    controller.favoriteList = try! container.resolve()
                    controller.context = try! container.resolve()
                    controller.request = try! container.resolve()
                }
            container.register(tag: "SearchController") { SearchController() }
                .resolvingProperties { container, controller in
                    controller.apiCalling = try! container.resolve()
                    controller.disposeBag = try! container.resolve()
                    controller.context = try! container.resolve()
                    controller.request = try! container.resolve()
                }
            container.register(tag: "TickDetail") { TickDetail() }
                .resolvingProperties { container, controller in
                    controller.apiCalling = try! container.resolve()
                    controller.context = try! container.resolve()
                    controller.disposeBag = try! container.resolve()
                    controller.lots = try! container.resolve()
                    controller.request = try! container.resolve()
                }
            container.register(tag: "UserAccount") { UserAccount() }
                .resolvingProperties { container, controller in
                    controller.apiCalling = try! container.resolve()
                    controller.context = try! container.resolve()
                    controller.disposeBag = try! container.resolve()
                    controller.lots = try! container.resolve()
                    controller.request = try! container.resolve()
                }
            container.register(tag: "ListOfSection") { ListOfSection() }
                .resolvingProperties { container, controller in
                    controller.context = try! container.resolve()
                    controller.list = try! container.resolve()
                }
            
            DependencyContainer.uiContainers = [container]
        }
    }
}



