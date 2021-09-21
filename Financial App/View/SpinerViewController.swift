//
//  SpinerViewController.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//

import UIKit

class SpinerViewController: UIViewController {

    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    

}
