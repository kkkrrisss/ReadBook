//
//  UIView+Ex.swift
//  ReadBook
//
//  Created by Кристина Олейник on 22.08.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
