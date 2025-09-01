//
//  AlertManager.swift
//  ReadBook
//
//  Created by Кристина Олейник on 25.08.2025.
//

import UIKit

final class AlertManager {
    static func showAlert(on viewController: UIViewController,
                          title: String = "Opsss".localized,
                          message: String,
                          buttonTitle: String = "Ok".localized) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle,
                                   style: .default)
        
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
    
    static func showActionShit(on viewController: UIViewController,
                               title: String,
                               message: String? = nil,
                               cancelMessage: String = "Cancel",
                               actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .actionSheet)
        
        actions.forEach { alert.addAction($0) }
        
        alert.addAction(UIAlertAction(title: cancelMessage,
                                      style: .cancel))
        
        viewController.present(alert, animated: true)
    }
}
