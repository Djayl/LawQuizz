//
//  GameViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 01/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit

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
    
    
    var thema = ""
    var gameTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSubViews()
        startTimer()
        themaLabel.text = thema
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func didTapDismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupViews() {
        viewA.layer.cornerRadius = viewA.frame.height/2
        viewB.layer.cornerRadius = viewB.frame.height/2
        viewc.layer.cornerRadius = viewc.frame.height/2
        viewD.layer.cornerRadius = viewD.frame.height/2
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
//          fetchQuestion()

      }
    
}
