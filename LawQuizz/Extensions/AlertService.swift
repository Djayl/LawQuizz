//
//  AlertService.swift
//  LawQuizz
//
//  Created by MacBook DS on 02/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class AlertService {
    
    func alert(title: String, body: String, buttonTitle: String, completion: @escaping () -> Void) -> AlertViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let alertVC = storyboard.instantiateViewController(identifier: "AlertVC") as! AlertViewController
        
        alertVC.alertTitle = title
        alertVC.alertBody = body
        alertVC.actionButtonTitle = buttonTitle
        alertVC.buttonAction = completion
        
        return alertVC
    }
    
     static func showAlert(style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .cancel, handler: nil)], completion: (() -> Swift.Void)? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            for action in actions {
                alert.addAction(action)
            }
            if let topVC = UIApplication.getTopMostViewController() {
                alert.popoverPresentationController?.sourceView = topVC.view
                alert.popoverPresentationController?.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
                alert.popoverPresentationController?.permittedArrowDirections = []
                topVC.present(alert, animated: true, completion: completion)
            }
        }
    }

    extension UIApplication {
        class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return getTopMostViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return getTopMostViewController(base: selected)
                }
            }
            if let presented = base?.presentedViewController {
                return getTopMostViewController(base: presented)
            }
            return base
        }
}
