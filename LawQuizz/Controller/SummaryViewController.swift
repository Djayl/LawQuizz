//
//  SummaryViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 06/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit

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
    
    var questions = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displaySummary()
    }
    
    private func displaySummary(){
   
            let questionLabels = [question1, question2, question3, question4, question5, question6, question7, question8, question9, question10]
            
            for (index, question) in questionLabels.enumerated() {
                question?.text = "\(questions[index].question) \n \(questions[index].goodAnswer)"
            }

        
    }

}
