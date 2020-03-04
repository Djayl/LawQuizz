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
    @IBOutlet weak var themaLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var button1Image: UIImageView!
    @IBOutlet weak var button2Image: UIImageView!
    @IBOutlet weak var button3Image: UIImageView!
    @IBOutlet weak var button4Image: UIImageView!
    @IBOutlet weak var countdownView: UIView!
    
    
    var thema = ""
    var gameTimer : Timer?
    var goodAnswer = ""
    var answersButton = [UIButton]()
    var score = 0
    var questionAnswered = 0
    let alertService = AlertService()
    var questions = [Question]()
    var counter = 20
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSubViews()
        setupCountDownView()
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
                
                stopTimer()
//                setTimerAndFecth()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.fetchQuestion()
                }
//                gameTimer?.invalidate()
//                counter = 5
//                scoreLabel.text = "Score: \(score)/\(questionAnswered)"
            } else {
                score += 0
                questionAnswered += 1
                
//                gameTimer?.invalidate()
                stopTimer()
//                counter = 5
                
//                setTimer()
//                scoreLabel.text = "Score: \(score)/\(questionAnswered)"
                let alertVC = alertService.alert(title: "Mauvaise réponse! 😐", body: "La bonne réponse était \(goodAnswer)", buttonTitle: "Merci pour l'info 👌🏽") { [weak self] in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self?.fetchQuestion()
                    }
                    
//                    self?.setTimerAndFecth()
//                    self?.gameTimer?.invalidate()
                }
                present(alertVC, animated: true)
            }
//        updateTotalQuestions()
//            gameOver()
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
    
    private func setupCountDownView() {
        countdownView.layer.cornerRadius = countdownView.frame.height/2
        countdownView.layer.borderWidth = 5
        countdownView.layer.borderColor = Colors.smoothBlue.cgColor
    }
    
//    func startTimer() {
//      progressView.progressTintColor = UIColor.systemGreen
//          progressView.trackTintColor = UIColor.clear
//          progressView.progress = 1.0
//          gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
//      }
      
//      @objc func updateProgressView() {
//          progressView.progress -= 0.01/30
//          if progressView.progress <= 0 {
//              outOfTime()
//          } else if progressView.progress <= 0.2 {
//              progressView.progressTintColor = UIColor.systemRed
//          } else if progressView.progress <= 0.5 {
//              progressView.progressTintColor = UIColor.systemOrange
//          }
//      }
      
      func outOfTime() {
        gameTimer?.invalidate()
        
          fetchQuestion()
      }
    
    private func fetchQuestion() {

        let category = "category1"
        let randomInt = Int.random(in: 1..<4)
        let answersButton = [buttonA, buttonB, buttonC, buttonD]
        let questionId = "q"+"\(randomInt)"
        
        
        let firestoreService = FirestoreService<Question>()
        firestoreService.fetchDocument(endpoint: .question(category: category, questionId:questionId)) { [weak self] result in
            switch result {
            case .success(let question):
                DispatchQueue.main.async {

                    self?.setTimer()
                }
//                self?.counter = 5
                print("NEW QUESTION")
//                self?.setTimer()
                self?.questions.append(question)
                self?.displayQuestion(question)
                
//                self?.startTimer()
                self?.setTitlesForButton(question)
                self?.hideImage()
                for button in answersButton {
                    button?.backgroundColor = Colors.clearBlue
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.presentAlert(with: "Erreur réseau")
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
    
    private func setTimerAndFecth() {
    
    gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimerAndFetch), userInfo: nil, repeats: true)
    }
    
    @objc func runTimerAndFetch() {
        
        counter -= 1
        timeLabel.text = "\(counter)"
        
        if counter == 0 {
            outOfTime()
            counter = 5
        }
        
    }
    
    private func setTimer() {
    
    gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runTimer() {
        setupCountdownLabel()
//        counter -= 1
//        timeLabel.text = "\(counter)"
//
//        if counter == 0 {
//            gameTimer?.invalidate()
//            counter = 5
//            fetchQuestion()
//        }
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
                    counter = 20
                    fetchQuestion()
        
                }
    }
    
    private func stopTimer() {
        gameTimer?.invalidate()
        counter = 20
//        timeLabel.text = "\(counter)"
    }
    
    private func setupCountdownLabel() {
        timeLabel.textColor = Colors.darkBlue
                   if counter <= 5 {
                    timeLabel.textColor = UIColor.systemRed
                  } else if counter <= 10 {
                    timeLabel.textColor = UIColor.systemOrange
                  }
    }


//    @objc func changeTitle() {
//
//        if counter != 0
//        {
//            timeLabel.isHidden = false
//            timeLabel.text = "\(counter)"
//            counter -= 1
//        }
//        else
//        {
//            timeLabel.isHidden = true
//            gameTimer?.invalidate()
//            fetchQuestion()
//
//            //              button.backgroundColor = // set any color
//        }
//
//    }
    
    private func timeOff() {
        if counter == 0 {
            fetchQuestion()
        }
    }
    
}
