//
//  ViewModel.swift
//  Financial App
//
//  Created by administrator on 12.10.21.
//

import RxSwift



class ViewModel {

    var list = PublishSubject<[List]>()
    var favorite = PublishSubject<[Favorite]>()

}
