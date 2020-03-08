//
//  SummaryViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 06/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit


@available(iOS 13.0, *)
class SummaryViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var question1: UILabel!
    @IBOutlet weak var question2: UILabel!
    @IBOutlet weak var question3: UILabel!
    @IBOutlet weak var question4: UILabel!
    @IBOutlet weak var question5: UILabel!
    @IBOutlet weak var question6: UILabel!
    @IBOutlet weak var question7: UILabel!
    @IBOutlet weak var question8: UILabel!
    @IBOutlet weak var question9: UILabel!
    @IBOutlet weak var question10: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    
    var questions = [Question]()
    var playerAnswers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displaySummary()
        replayButton.layer.cornerRadius = 10
    }
    
    private func displaySummary(){
        let questionLabels = [question1, question2, question3, question4, question5, question6, question7, question8, question9, question10]
        
        for (index, question) in questionLabels.enumerated() {
            if playerAnswers[index] == questions[index].goodAnswer {
                question?.textColor = Colors.green
                question?.text = "\(questions[index].question)\n"+"Votre réponse: "+"\(playerAnswers[index])"
            } else {
                question?.textColor = Colors.red
                question?.text = "\(questions[index].question)\n"+"Votre réponse: "+"\(playerAnswers[index])\n"+"La bonne réponse était: "+"\(questions[index].goodAnswer)"
            }
        }
    }
    @IBAction func didTapReplay(_ sender: Any) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
}
