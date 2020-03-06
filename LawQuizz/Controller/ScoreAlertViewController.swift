//
//  ScoreAlertViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 05/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class ScoreAlertViewController: UIViewController {
    
    
    @IBOutlet weak var scoreImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var scoreImage : UIImage?
    var alertTitle = ""
    var alertScore = ""
    var alertBody = ""
    var questions = [Question]()
//    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barTintColor = Colors.darkBlue
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SummaryVC") as! SummaryViewController
        secondVC.questions = questions
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func setupView() {
        titleLabel.text = alertTitle
        bodyLabel.text = alertBody
        scoreImageView.image = scoreImage
        scoreLabel.text = alertScore
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
//        scoreImageView.layer.cornerRadius = scoreImageView.frame.height/2
    }
    
}
