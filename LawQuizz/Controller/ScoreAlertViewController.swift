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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var shareButton: ButtonWithImage!
    
    
    var scoreImage : UIImage?
    var alertTitle = ""
    var alertScore = ""
    var alertBody = ""
    var questions = [Question]()
    var playerAnswers = [String]()
//    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupShareButtonShadow()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barTintColor = Colors.darkBlue
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SummaryVC") as! SummaryViewController
        secondVC.questions = questions
        secondVC.playerAnswers = playerAnswers
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        let item = "Je viens de faire un score de \(alertScore) à Nemo!"
        let activityController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    private func setupShareButtonShadow() {
              shareButton.layer.shadowColor   = UIColor.black.cgColor
              shareButton.layer.shadowOffset  = CGSize(width: 0.0, height: 1.0)
              shareButton.layer.shadowRadius  = 3
              shareButton.layer.shadowOpacity = 0.3
              shareButton.clipsToBounds       = true
              shareButton.layer.masksToBounds = false
          }
    
    func setupView() {
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.setTitle("Partager", for: .normal)
        shareButton.layer.cornerRadius = 10
        titleLabel.text = alertTitle
        scoreImageView.image = scoreImage
        scoreLabel.text = "Score "+"\(alertScore)"
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
//        scoreImageView.layer.cornerRadius = scoreImageView.frame.height/2
    }
    
}
