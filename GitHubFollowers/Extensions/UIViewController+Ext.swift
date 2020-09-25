//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve /// fades in
            self.present(alertVC, animated: true)
        }
    }
    
    func presentSafariVC(with url: URL) {
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
}

/*
EDUCATIONAL NOTES:
    - "import UIKit": includes Foundation, importing both is redundant
    - "fileprivate var containerView: UIView!" -> fileprivate: anything in this file can use this variable
        - old code used this, but containerView was refactored to GFDataLoadingVC
    - "DispatchQueue.main.async": quick way to throw things on the Main Thread
        - illegal to call a View when not on the main thread (Cannot do it from a background thread)
    - extensions: can't create variables in them
*/

