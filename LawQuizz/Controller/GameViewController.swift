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
    @IBOutlet weak var subViewA: ViewShadowed!
    @IBOutlet weak var subViewB: ViewShadowed!
    @IBOutlet weak var subViewC: ViewShadowed!
    @IBOutlet weak var subViewD: ViewShadowed!
    @IBOutlet weak var themaLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var button1Image: UIImageView!
    @IBOutlet weak var button2Image: UIImageView!
    @IBOutlet weak var button3Image: UIImageView!
    @IBOutlet weak var button4Image: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    var thema = ""
    var gameTimer : Timer?
    var goodAnswer = ""
    var answersButton = [UIButton]()
    var score = 0
    var questionAnswered = 0
    let alertService = AlertService()
    var questions = [Question]()
    var counter = 20
    var scorePercentage = 0
    var wrongAnswers = 0
    var playerAnswers = [String]()
    var userGoodAnswers = 0
    var userTotalQuestions = 0
    var userSchool = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSubViews()
        themaLabel.text = thema
        fetchQuestion()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func didTapDismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setupImage(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            checkMark(sender, button1Image)
        case 2:
            checkMark(sender, button2Image)
        case 3:
            checkMark(sender, button3Image)
        case 4: 
            checkMark(sender, button4Image)
        default:
            print("nothing")
        }
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        if sender.titleLabel?.text == goodAnswer {
            score += 1
            questionAnswered += 1
            gameTimer?.invalidate()
            enableButtons()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.fetchQuestion()
            }
        } else {
            questionAnswered += 1
            wrongAnswers += 1
            gameTimer?.invalidate()
            enableButtons()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.fetchQuestion()
            }
        }
        disableButtons()
        scoreLabel.text = "Score: \(score)/\(questionAnswered)"
        guard let playerAnswer = sender.titleLabel?.text else {return}
        playerAnswers.append(playerAnswer)
        gameOver()
    }
    
    private func calculateScore() {
        let percentage = (score/questionAnswered) * 100
        scorePercentage = percentage
    }
    
    private func disableButtons() {
        let buttons = [buttonA, buttonB, buttonC, buttonD]
        for button in buttons {
            button?.isEnabled = false
        }
    }
    
    private func enableButtons() {
        let buttons = [buttonA, buttonB, buttonC, buttonD]
        for button in buttons {
            button?.isEnabled = true
        }
    }

    private func checkMark(_ sender: UIButton, _ image: UIImageView) {
        image.layer.cornerRadius = image.frame.height/2
        image.isHidden = false
        if sender.titleLabel?.text == goodAnswer {
            
            image.image = UIImage(named: "correct")
        } else {
            image.image = UIImage(named: "close")
        }
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
    
    private func startTimer() {
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
      
      private func outOfTime() {
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.progressView.alpha = 0.0
            self.gameTimer?.invalidate()
            self.fetchQuestion()
        }
//        gameTimer?.invalidate()
//          fetchQuestion()
      }
    
    private func fetchQuestion() {
        
        let category = "category1"
        let randomInt = Int.random(in: 1..<4)
        let answersButton = [buttonA, buttonB, buttonC, buttonD]
        let questionId = "q"+"\(randomInt)"
        
        if questionAnswered != 10 {
        let firestoreService = FirestoreService<Question>()
        firestoreService.fetchDocument(endpoint: .question(category: category, questionId:questionId)) { [weak self] result in
            switch result {
            case .success(let question):

                print("NEW QUESTION")

                self?.questions.append(question)
                self?.displayQuestion(question)
                self?.startTimer()
                self?.setTitlesForButton(question)
                self?.hideImage()
                self?.enableButtons()
                for button in answersButton {
                    button?.backgroundColor = Colors.clearBlue
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.presentAlert(with: "Erreur réseau")
            }
        }
        }
    }
    
    private func hideImage() {
        button1Image.isHidden = true
        button2Image.isHidden = true
        button3Image.isHidden = true
        button4Image.isHidden = true
    }
    
    private func setupButtonImage() {
        button1Image.layer.cornerRadius = button1Image.frame.height/2
        button2Image.layer.cornerRadius = button2Image.frame.height/2
        button2Image.layer.cornerRadius = button2Image.frame.height/2
        button2Image.layer.cornerRadius = button2Image.frame.height/2
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
    

    private func updateScoreInFirestore() {
        let firestoreService = FirestoreService<Profil>()
        let data = ["totalQuestions": FieldValue.increment(Int64(questionAnswered)),
                    "goodAnswers": FieldValue.increment(Int64(score)),
                    "wrongAnswers": FieldValue.increment(Int64(wrongAnswers))]
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
    
    private func updateSchoolScoreInFirestore() {
        let firestoreService = FirestoreService<School>()
        let data = ["goodAnswers": FieldValue.increment(Int64(score))]
        
        firestoreService.updateData(endpoint: .school(schoolId: userSchool), data: data) { [weak self] result in
            switch result {
            case .success(let successMessage):
                print(successMessage)
            case .failure(let error):
                print("Error adding document: \(error)")
                self?.presentAlert(with: "Erreur réseau")
            }
        }
    }
    
    func gameOver() {
        if questionAnswered == 10 {
            updateScoreInFirestore()
            updateSchoolScoreInFirestore()
           let scoreLabel = score*10
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "ScoreAlertVC") as!
            ScoreAlertViewController
            secondVC.questions = questions
            secondVC.playerAnswers = playerAnswers
            switch score {
            case 0..<3 :
                print(scorePercentage)
                secondVC.alertScore = "\(scoreLabel)%"
                secondVC.alertTitle = "Aïe..."
//                secondVC.alertBody = "Ressaisissez-vous!"
                secondVC.scoreImage = UIImage(named: "angry")
            case 3..<5:
                print(scorePercentage)
                secondVC.alertScore = "\(scoreLabel)%"
                secondVC.alertTitle = "Mouais..."
//                secondVC.alertBody = "Peut mieux faire."
                secondVC.scoreImage = UIImage(named: "confused")
            case 5..<7:
                print(scorePercentage)
                secondVC.alertScore = "\(scoreLabel)%"
                secondVC.alertTitle = "Pas mal du tout"
//                secondVC.alertBody = "Vous avez fait du bon boulot"
                secondVC.scoreImage = UIImage(named: "like")
            case 7...10:
                print(scorePercentage)
                secondVC.alertScore = "\(scoreLabel)%"
                secondVC.alertTitle = "Félicitations!"
//                secondVC.alertBody = "Vous êtes impressionnant."
                secondVC.scoreImage = UIImage(named: "trophy")
            default:
                print("score shown")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.navigationController?.pushViewController(secondVC, animated: true)
            }

        }
    }
}

