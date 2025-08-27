//
//  AlertManager.swift
//  ReadBook
//
//  Created by Кристина Олейник on 25.08.2025.
//

import UIKit

final class AlertManager {
    static func showAlert(on viewController: UIViewController,
                          title: String = "Opsss",
                          message: String,
                          buttonTitle: String = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default)
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
