//
//  AlertViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 02/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var alertTitle = ""
    var alertBody = ""
    var actionButtonTitle = ""
    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        titleLabel.text = alertTitle
        bodyLabel.text = alertBody
        actionButton.setTitle(actionButtonTitle, for: .normal)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        actionButton.layer.cornerRadius = 5
    }

    @IBAction func didTapAction(_ sender: Any) {
        dismiss(animated: true)
        buttonAction?()
    }
    
}
