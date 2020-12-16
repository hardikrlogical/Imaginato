//
//  CustomAlertController.swift
//  imaginato
//
//  Created by rlogical-dev-35 on 14/12/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//


import UIKit

extension UIAlertController {
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else if let tabVC = controller as? UITabBarController,
            let selectedVC = tabVC.selectedViewController {
            presentFromController(controller: selectedVC, animated: animated, completion: completion)
        } else {
            controller.present(self, animated: animated, completion: completion)
        }
    }
}

class CustomAlertController: NSObject {
    
    /**
     Show AlertView Methods
     
     - parameter title:   title
     - parameter message: message
     */
    
    class func showtitleMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(OKAction)
        alertController.show()
    }
    
    class func showtitleMessage(title: String, message: String, CompletionHandler completion:@escaping (_ success: Bool)-> Void) {
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            completion(true)
        }
        alertController.addAction(OKAction)
        alertController.show()
    }
    
    /**
     Show AlertView Methods
     
     - parameter message: message
     */
    class func show(_ message: String) {
        self.showtitleMessage(title: kProjectName, message: message)
    }
    
    class func show(message: String, CompletionHandler completion:@escaping (_ success: Bool) -> Void) {
        showtitleMessage(title: kProjectName, message: message, CompletionHandler: completion)
    }
    
    class func showUnderDevelopmentAlert() {
        self.showtitleMessage(title: "Under Development!", message: "This feature is under development and will be available in future releases.")
    }
}
