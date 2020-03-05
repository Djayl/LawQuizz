//
//  ViewShadowed.swift
//  LawQuizz
//
//  Created by MacBook DS on 05/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ViewShadowed: UIView {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Methods
    
    func setupView() {
        setShadow()
    }
    
    private func setShadow() {
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius  = 5
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
}
}
