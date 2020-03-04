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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
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
    
}
