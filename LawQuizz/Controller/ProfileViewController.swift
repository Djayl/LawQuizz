//
//  ProfileViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 04/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var goodAnswersLabel: UILabel!
    @IBOutlet weak var wrongAnswersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setDeleteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = Colors.darkBlue
        listenProfilInformation()
    }
    private func setupImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    private func updateScreenWithProfil(_ profil: Profil) {
        usernameLabel.text = "\(profil.userName.capitalized)"
        schoolLabel.text = "\(profil.school.capitalized)"
        goodAnswersLabel.text = "Total bonnes réponses: "+"\(profil.goodAnswers)"
        wrongAnswersLabel.text = "Total mauvaises réponses: "+"\(profil.wrongAnswers)"
    }
    
    private func getImage(_ profil: Profil) {
        let urlString = profil.imageURL
        guard let url = URL(string: urlString) else {return}
        KingfisherManager.shared.retrieveImage(with: url, options: nil) { result in
            let image = try? result.get().image
            if let image = image {
                self.profileImageView.image = image
            }
        }
    }
    
    private func listenProfilInformation() {
        let firestoreService = FirestoreService<Profil>()
        firestoreService.listenDocument(endpoint: .currentUser) { [weak self] result in
            switch result {
            case .success(let profil):
                self?.updateScreenWithProfil(profil)
                self?.getImage(profil)
            case .failure(let error):
                print(error.localizedDescription)
                self?.presentAlert(with: "Erreur réseau")
            }
        }
    }
    
    @objc private func logOut() {
           presentAlertWithAction(message: "Êtes-vous sûr de vouloir vous déconnecter?") {
               let authService = AuthService()
               do {
                   try authService.signOut()
               } catch let signOutError as NSError {
                   print ("Error signing out: %@", signOutError)
               }
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let initial = storyboard.instantiateInitialViewController()
               UIApplication.shared.keyWindow?.rootViewController = initial
           }
       }
    
    private func setDeleteButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "logout"), for: .normal)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
    
}
