//
//  CircleView.swift
//  ZemogaTestEP
//
//  Created by Emilio Portocarrero on 5/12/22.
//

import UIKit

class CircleView: UIView {
    @IBInspectable var borderColor: UIColor? {
        didSet {
            setupView()
        }
    }
    override func awakeFromNib() {
        setupView()
    }
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
    }
}
