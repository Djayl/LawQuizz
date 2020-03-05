//
//  HomeViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 03/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit
import Kingfisher

@available(iOS 13.0, *)
class HomeViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var theme1Button: UIButton!
    @IBOutlet weak var theme2Button: UIButton!
    @IBOutlet weak var theme3Button: UIButton!
    @IBOutlet weak var theme4Button: UIButton!
    @IBOutlet weak var theme5Button: UIButton!
    @IBOutlet weak var themeStackView: UIStackView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
//        setupProfileImageView()
        setupScoreView()
        setupStackView()
        toggleButtons()
        setupImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserLoggedIn()
        listenProfilInformation()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.addBottomRoundedCornerToView(targetView: topView, desiredCurve: 2)
        setupTopView()
    }
    
    @IBAction func didTapThema(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else {return}
        switch sender.tag {
        case 0:
            pushToGameVC("\(title)")
        case 1:
            pushToGameVC("\(title)")
        case 2:
            pushToGameVC("\(title)")
        case 3:
            pushToGameVC("\(title)")
        case 4:
            pushToGameVC("\(title)")
        default:
        print("No button tapped")
        }
    }
    
    @IBAction func goToProfile(_ sender: Any) {
         let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
               
               self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    
    private func pushToGameVC(_ data: String) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
        secondViewController.thema = data
            self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    private func setupTopView() {
        topView.layer.shadowColor   = UIColor.black.cgColor
        topView.layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        topView.layer.shadowRadius  = 8
        topView.layer.shadowOpacity = 0.5
        topView.clipsToBounds       = true
        topView.layer.masksToBounds = false
    }
    
    private func setupButtons() {
        theme1Button.layer.cornerRadius = 10
        theme2Button.layer.cornerRadius = 10
        theme3Button.layer.cornerRadius = 10
        theme4Button.layer.cornerRadius = 10
        theme5Button.layer.cornerRadius = 10
    }
    

    private func setupScoreView() {
        scoreView.layer.cornerRadius = 10
        scoreView.layer.shadowColor   = UIColor.black.cgColor
        scoreView.layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
        scoreView.layer.shadowRadius  = 8
        scoreView.layer.shadowOpacity = 0.5
        scoreView.clipsToBounds       = true
        scoreView.layer.masksToBounds = false
    }
    
    private func setupStackView() {
        for view in themeStackView.arrangedSubviews
        {
           view.layer.shadowColor   = UIColor.black.cgColor
           view.layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
           view.layer.shadowRadius  = 8
           view.layer.shadowOpacity = 0.5
           view.clipsToBounds       = true
           view.layer.masksToBounds = false
        }
    }
    
    private func toggleButtons() {
        theme1Button.setBackgroundColor(color: Colors.clearBlue, forState: .selected)
    }
    
    private func checkIfUserLoggedIn() {
           DispatchQueue.main.async {
               if AuthService.getCurrentUser() == nil {
                   let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                   let nc = UINavigationController(rootViewController: vc)
                   nc.modalPresentationStyle = .fullScreen
                   self.present(nc, animated: true, completion: nil)
               }
           }
       }
    
    private func getProfilInfos(_ profil: Profil) {
        totalLabel.text = "\(profil.totalQuestions)"
    }
    
    private func setupImageView() {
        profileButton.layer.cornerRadius = profileButton.frame.height / 2
        profileButton.clipsToBounds = true
    }
    
    private func getProfileImage(_ profil: Profil) {
        let urlString = profil.imageURL
        guard let url = URL(string: urlString) else {return}
        KingfisherManager.shared.retrieveImage(with: url, options: nil) { result in
            let image = try? result.get().image
            if let image = image {
                self.profileButton.setImage(image, for: .normal)
            }
        }
    }
    
    private func listenProfilInformation() {
           let firestoreService = FirestoreService<Profil>()
           firestoreService.listenDocument(endpoint: .currentUser) { [weak self] result in
               switch result {
               case .success(let profil):
                   self?.getProfileImage(profil)
                   self?.getProfilInfos(profil)
               case .failure(let error):
                   print(error.localizedDescription)
                   self?.presentAlert(with: "Erreur réseau")
               }
           }
       }


}
