//
//  GameViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 01/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit
import Firebase

@available(iOS 13.0, *)
class GameViewController: UIViewController {
    
    @IBOutlet weak var viewA: UIView!
    @IBOutlet weak var viewB: UIView!
    @IBOutlet weak var viewc: UIView!
    @IBOutlet weak var viewD: UIView!
    @IBOutlet weak var subViewA: UIView!
    @IBOutlet weak var subViewB: UIView!
    @IBOutlet weak var subViewC: UIView!
    @IBOutlet weak var subViewD: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var themaLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var thema = ""
    var gameTimer : Timer?
    var goodAnswer = ""
    var answersButton = [UIButton]()
    var score = 0
    var questionAnswered = 0
    let alertService = AlertService()
    var questions = [Question]()
    var counter = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSubViews()
//        startTimer()
        themaLabel.text = thema
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        fetchQuestion()
//        setTimer()
    }
    
    @IBAction func didTapDismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
      @IBAction func checkAnswer(_ sender: UIButton) {
            if sender.titleLabel?.text == goodAnswer {
                score += 1
                questionAnswered += 1
                sender.backgroundColor = UIColor.systemGreen
                fetchQuestion()
                gameTimer?.invalidate()
                
//                scoreLabel.text = "Score: \(score)/\(questionAnswered)"
            } else {
                score += 0
                questionAnswered += 1
                sender.backgroundColor = UIColor.systemRed
                gameTimer?.invalidate()
                
//                scoreLabel.text = "Score: \(score)/\(questionAnswered)"
                let alertVC = alertService.alert(title: "Mauvaise réponse! 😐", body: "La bonne réponse était \(goodAnswer)", buttonTitle: "Merci pour l'info 👌🏽") { [weak self] in
                    self?.fetchQuestion()
//                    self?.gameTimer?.invalidate()
                }
                present(alertVC, animated: true)
            }
        updateTotalQuestions()
//            gameOver()
        }
    
    private func setupViews() {
        viewA.layer.cornerRadius = viewA.frame.height/2
        viewB.layer.cornerRadius = viewB.frame.height/2
        viewc.layer.cornerRadius = viewc.frame.height/2
        viewD.layer.cornerRadius = viewD.frame.height/2
        
        viewA.clipsToBounds = true
        viewB.clipsToBounds = true
        viewc.clipsToBounds = true
        viewD.clipsToBounds = true
    }
    
    private func setupSubViews() {
        subViewA.layer.cornerRadius = subViewA.frame.height/2
        subViewB.layer.cornerRadius = subViewB.frame.height/2
        subViewC.layer.cornerRadius = subViewC.frame.height/2
        subViewD.layer.cornerRadius = subViewD.frame.height/2
    }
    
    func startTimer() {
      progressView.progressTintColor = UIColor.systemGreen
          progressView.trackTintColor = UIColor.clear
          progressView.progress = 1.0
          gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
      }
      
      @objc func updateProgressView() {
          progressView.progress -= 0.01/30
          if progressView.progress <= 0 {
              outOfTime()
          } else if progressView.progress <= 0.2 {
              progressView.progressTintColor = UIColor.systemRed
          } else if progressView.progress <= 0.5 {
              progressView.progressTintColor = UIColor.systemOrange
          }
      }
      
      func outOfTime() {
        gameTimer?.invalidate()
          fetchQuestion()
      }
    
    private func fetchQuestion() {
//        counter = 10
//        setTimer()
        let category = "category1"
        let randomInt = Int.random(in: 1..<4)
        let answersButton = [buttonA, buttonB, buttonC, buttonD]
        let questionId = "q"+"\(randomInt)"
        
        
        let firestoreService = FirestoreService<Question>()
        firestoreService.fetchDocument(endpoint: .question(category: category, questionId:questionId)) { [weak self] result in
            switch result {
            case .success(let question):
                DispatchQueue.main.async {
                    self?.counter = 5
                    self?.setTimer()
                }
                
                self?.questions.append(question)
                self?.displayQuestion(question)
                
//                self?.startTimer()
                self?.setTitlesForButton(question)
                for button in answersButton {
                    button?.backgroundColor = Colors.clearBlue
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.presentAlert(with: "Erreur réseau")
            }
        }
    }
    
    private func displayQuestion(_ question: Question) {
        questionLabel.text = question.question
    }
    
    private func setTitlesForButton(_ question: Question) {
        buttonA.setTitle(question.answer1, for: .normal)
        buttonB.setTitle(question.answer2, for: .normal)
        buttonC.setTitle(question.answer3, for: .normal)
        buttonD.setTitle(question.answer4, for: .normal)
        goodAnswer = question.goodAnswer
    }
    
//    func gameOver() {
//        if questionAnswered == 10 {
//            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScoreVC") as! ScoreViewController
//            secondViewController.score = score
//            secondViewController.questionAnswered = questionAnswered
//            secondViewController.questions = questions
//            self.navigationController?.pushViewController(secondViewController, animated: true)
//        }
//    }

    private func updateTotalQuestions() {
//           guard let equipment = self.equipmentTextField.text else {return}
        let firestoreService = FirestoreService<Profil>()
        let data = ["totalQuestions": FieldValue.increment(Int64(1))]
        firestoreService.updateData(endpoint: .currentUser, data: data) { [weak self] result in
                   switch result {
                   case .success(let successMessage):
                       print(successMessage)
                   case .failure(let error):
                       print("Error adding document: \(error)")
                       self?.presentAlert(with: "Erreur réseau")
                   }
               }
          
       }
    
    private func setTimer() {
    
    gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeTitle), userInfo: nil, repeats: true)
    }

    @objc func changeTitle() {
    
         if counter != 0
         {
            timeLabel.isHidden = false
            timeLabel.text = "\(counter)"
             counter -= 1
         }
         else
         {
            timeLabel.isHidden = true
            gameTimer?.invalidate()
               fetchQuestion()
            
//              button.backgroundColor = // set any color
         }
        
    }
    
}
