//
//  FinhubDetail.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit

class TickDetail: UIViewController, Storyboarded {
    
    var coordinator : MainCoordinator?
    var fm = FinhubManager()
    var ticker : String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configNavigator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fm.loadDataCompany(completion: { finhub in
            print(finhub)
        }, ticker: ticker ?? "")
        // Do any additional setup after loading the view.
    }
    
    func configNavigator() {
        let nav = self.navigationController?.navigationBar
        
        nav?.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        nav?.isTranslucent = false
        nav?.backItem?.title = ""
        nav?.topItem?.title = ticker
        nav?.tintColor = .darkGray
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
