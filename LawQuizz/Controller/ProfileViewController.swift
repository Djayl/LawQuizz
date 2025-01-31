//
//  ProfileViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 04/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit
import Kingfisher

@available(iOS 13.0, *)
class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var goodAnswersLabel: UILabel!
    @IBOutlet weak var userRank: UILabel!
    @IBOutlet weak var schoolUserRank: UILabel!
    
    var allUsers = [String:Double]()
    var schoolUsers = [String:Double]()
    var userID = ""
    var userSchool = ""
    var usersSorted = [(key: String, value: Double)]()
    var schoolUsersSorted = [(key: String, value: Double)]()
    var users = [String]()
    var fellows = [String]()
    var utilisateurs = [Profil]()
    var camarades = [Profil]()
    var generalRank = ""
    var schoolRank = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setDeleteButton()
        IAPService.shared.getProducts()
        
//        getAllUsersPosition()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = Colors.darkBlue
        listenProfilInformation()
        displayGeneralRank()
        displaySchoolRank()
//        fecthUsersCollection()
        
    }
    
    @IBAction func didTapPurchase(_ sender: Any) {
        IAPService.shared.purchase(product: .autoRenewableSubscription)
    }
    
    @IBAction func didTapRestore(_ sender: Any) {
        IAPService.shared.restorePurchases()
    }
    
    private func setupImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
    }
    private func updateScreenWithProfil(_ profil: Profil) {
        usernameLabel.text = "\(profil.userName.capitalized)"
        schoolLabel.text = "\(profil.school.capitalized)"
        userID = profil.identifier
        userSchool = profil.school
    }
    
    private func calculateGoodAnswers(_ profil: Profil) {
        let goodAnswers = Double(profil.goodAnswers)
        let totalAnswers = Double(profil.totalQuestions)
        let percentage1 = Double((goodAnswers / totalAnswers )*100)
        let percentage1Rounded = String(format: "%.1f", percentage1)
        if percentage1 <= 35 {
            goodAnswersLabel.textColor = Colors.red
        } else if percentage1 <= 60 {
            goodAnswersLabel.textColor = Colors.orange
        } else {
            goodAnswersLabel.textColor = Colors.green
        }
        
        goodAnswersLabel.text = "Bonnes réponses: "+"\(percentage1Rounded)%"
        
    }
    
    private func setRankingIfNoData(_ profil: Profil) {
        if profil.totalQuestions == 0 {
            goodAnswersLabel.text = "Aucune donnée à afficher"
            userRank.text = "Aucune donnée à afficher"
            schoolUserRank.text = "Aucune donnée à afficher"
        }
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
    
    private func setAllUsersDictionary(_ profil: Profil) {
        guard profil.totalQuestions != 0 else {
            userRank.text = "Classement général: Aucune donnée à afficher"
            return}
        let userGoodAnswers = Double(profil.goodAnswers)
        let userTotalQuestions = Double(profil.totalQuestions)
        let userId = profil.identifier
        let average = Double(userGoodAnswers / userTotalQuestions)
        let averageTruncated = average.truncateDigitsAfterDecimal(number: average, afterDecimalDigits: 4)
        allUsers.updateValue(averageTruncated, forKey: userId)
        usersSorted = allUsers.sorted(by: { $0.value > $1.value })
    }
    
    private func setSchoolUsersDictionary(_ profil: Profil) {
        guard profil.totalQuestions != 0 else {
            schoolUserRank.text = "Classement à \(userSchool): Aucune donnée à afficher"
            return}
        let userGoodAnswers = Double(profil.goodAnswers)
        let userTotalQuestions = Double(profil.totalQuestions)
        let userId = profil.identifier
        let average = Double(userGoodAnswers / userTotalQuestions)
        let averageTruncated = average.truncateDigitsAfterDecimal(number: average, afterDecimalDigits: 4)
        schoolUsers.updateValue(averageTruncated, forKey: userId)
        schoolUsersSorted = schoolUsers.sorted(by: { $0.value > $1.value })
    }
    
    private func getCurrentUserPositionInSchool() {
        
        for (item) in schoolUsersSorted.enumerated() {
            
            if item.element.key == userID {
                print("\((item.offset) + 1): \(item.element.key) : \(item.element.value)")
                if ((item.offset) + 1) == 1 {
                    schoolUserRank.text = "Classement à \(userSchool): \((item.offset) + 1)er"
                } else {
                    schoolUserRank.text = "Classement à \(userSchool): \((item.offset) + 1)ème"
                }
            }
        }
    }
    
    private func getAllUsersPosition() {
        for (item) in usersSorted.enumerated() {
            users.append(item.element.key)
        }        
    }
    
    private func getCurrentUserPosition() {
        
        for (item) in usersSorted.enumerated() {
            
            if item.element.key == userID {
                print("\((item.offset) + 1): \(item.element.key) : \(item.element.value)")
                if ((item.offset) + 1) == 1 {
                    userRank.text = "Classement général: \((item.offset) + 1)er"
                } else {
                    userRank.text = "Classement général: \((item.offset) + 1)ème"
                }
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
                self?.calculateGoodAnswers(profil)
                self?.setRankingIfNoData(profil)
            case .failure(let error):
                print(error.localizedDescription)
                self?.presentAlert(with: "Erreur réseau")
            }
        }
    }
    
//    private func listenUsersCollection() {
//        let firestoreService = FirestoreService<Profil>()
//        firestoreService.listenCollection(endpoint: .user) { [weak self] result in
//            switch result {
//            case .success(let users):
//                for user in users {
//                    self?.setAllUsersDictionary(user)
//                    if user.school == self?.userSchool {
//                        self?.setSchoolUsersDictionary(user)
//                        print(self?.userSchool as Any)
//                    }
//                }
//                self?.getCurrentUserPosition()
//                self?.getCurrentUserPositionInSchool()
//                self?.getAllUsersPosition()
//            case .failure(let error):
//                print(error.localizedDescription)
//                self?.presentAlert(with: "Erreur réseau")
//            }
//        }
//    }
    
    
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
        button.setTitle("Déconnexion", for: .normal)
        button.setTitleColor(Colors.clearBlue, for: .normal)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
    
//    private func fecthUsersCollection() {
//        let firestoreService = FirestoreService<Profil>()
//        firestoreService.fetchCollection(endpoint: .user) { [weak self] result in
//            switch result {
//            case .success(let users):
//                self?.utilisateurs = users.sorted {
//                    $0.rank > $1.rank
//                }
//                self?.camarades.removeAll()
//                for user in users {
//                    if user.school == self?.userSchool {
//                        self?.camarades.append(user)
//                        self?.camarades.sort {
//                            $0.rank > $1.rank
//                        }
//                    }
//                }
//                print(self?.userSchool as Any)
//                print(self?.camarades.count as Any)
//                self?.setRank()
//                self?.setSchoolRank()
//            case .failure(let error):
//                print(error.localizedDescription)
//                self?.presentAlert(with: "Erreur réseau")
//            }
//        }
//    }
//
    private func displayGeneralRank() {
        
        userRank.text = "Classement général: \(generalRank)"
    }
    
    private func displaySchoolRank() {
        
        schoolUserRank.text =  "Classement école: \(schoolRank)"
    }
    
}
