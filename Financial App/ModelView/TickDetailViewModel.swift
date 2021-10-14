//
//  TickDetailViewModel.swift
//  Financial App
//
//  Created by administrator on 13.10.21.
//

import Foundation
import Dip
import RxSwift


class TickDetailViewModel {
    
    var apiCalling : APICalling!
    var disposeBag : DisposeBag!
    var lots : [Lots]!
    var request : APIRequest!
    var quote : Observable<Quote>!
    var stock : Observable<StockHandelData>!
    var company : Observable<FinhubCompany>!
    
    var reloadView : (() -> Void)?
    
    //MARK: - Data Manipulations
    

    
    
    
}
