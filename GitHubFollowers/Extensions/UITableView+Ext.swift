//
//  UITableView+Ext.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 7/2/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

extension UITableView {
    
    func removeExtraCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    /*
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    */
}

/// "reloadDataOnMainThread()": if using TableViews often... can be useful bc if reloading table on network call; need to be on main thread for a call like this

