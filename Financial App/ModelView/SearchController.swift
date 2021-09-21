//
//  SearchController.swift
//  Financial App
//
//  Created by administrator on 21.09.21.
//
import UIKit

extension ViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
}


