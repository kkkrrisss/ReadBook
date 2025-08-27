//
//  UIStackView+Ex.swift
//  ReadBook
//
//  Created by Кристина Олейник on 22.08.2025.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}

