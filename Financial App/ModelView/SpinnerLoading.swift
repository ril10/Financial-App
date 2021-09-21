//
//  Spinner.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//
import UIKit

extension ViewController {
    
    func createSpinnerView() {
        let child = SpinerViewController()

        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
}

