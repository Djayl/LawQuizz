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
    @IBOutlet weak var generalRankButton: UIButton!
    @IBOutlet weak var schoolRankButton: UIButton!
    @IBOutlet weak var generalRank: UILabel!
    @IBOutlet weak var schoolRank: UILabel!
    
    
    var allUsers = [Profil]()
    var fellows = [Profil]()
    var userSchool = ""
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupButtons()
        setupScoreView()
        setupStackView()
        toggleButtons()
        setupImageView()
        setupSchoolRankButton()
        setupGeneralRankButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserLoggedIn()
        listenProfilInformation()
        fecthUsersCollection()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.addBottomRoundedCornerToView(targetView: topView, desiredCurve: 2)
        setupTopView()
    }
    @IBAction func goToGeneralrank(_ sender: Any) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "GeneralRankingVC") as! GeneralRankingViewController
        secondVC.users = allUsers
        secondVC.userID = userID
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    @IBAction func goToSchoolRank(_ sender: Any) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "RankingVC") as! RankingViewController
        secondVC.users = fellows
        secondVC.userID = userID
        secondVC.userSchool = userSchool
        secondVC.navigationItem.title = "Classement école"
        self.navigationController?.pushViewController(secondVC, animated: true)
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
         let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        guard let generalRank = generalRank.text else {return}
        guard let schoolRank = schoolRank.text else {return}
        secondVC.generalRank = generalRank
        secondVC.schoolRank = schoolRank
         self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    fileprivate func setupNavigationBar() {
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }
    
    private func pushToGameVC(_ data: String) {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
        secondViewController.thema = data
        secondViewController.userSchool = userSchool
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
    
    private func setupProfileButtonShadow() {
           profileButton.layer.shadowColor   = UIColor.black.cgColor
           profileButton.layer.shadowOffset  = CGSize(width: 0.0, height: 3.0)
           profileButton.layer.shadowRadius  = 5
           profileButton.layer.shadowOpacity = 0.5
           profileButton.clipsToBounds       = true
           profileButton.layer.masksToBounds = true
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
    
    private func setupGeneralRankButton() {
        schoolRankButton.layer.cornerRadius = schoolRankButton.frame.height / 2
        schoolRankButton.layer.shadowColor   = UIColor.black.cgColor
        schoolRankButton.layer.shadowOffset  = CGSize(width: 0.0, height: 3.0)
        schoolRankButton.layer.shadowRadius  = 5
        schoolRankButton.layer.shadowOpacity = 0.5
//        schoolRankButton.clipsToBounds       = true
//        schoolRankButton.layer.masksToBounds = false
    }
    
    private func setupSchoolRankButton() {
        generalRankButton.layer.cornerRadius = generalRankButton.frame.height / 2
        generalRankButton.layer.shadowColor   = UIColor.black.cgColor
        generalRankButton.layer.shadowOffset  = CGSize(width: 0.0, height: 3.0)
        generalRankButton.layer.shadowRadius  = 5
        generalRankButton.layer.shadowOpacity = 0.5
//        generalRankButton.clipsToBounds       = true
//        generalRankButton.layer.masksToBounds = false
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
//        totalLabel.text = "\(profil.totalQuestions)"
        userSchool = profil.school
        userID = profil.identifier
    }
    
    private func setupImageView() {
        profileButton.layer.cornerRadius = profileButton.frame.height / 2
        profileButton.clipsToBounds = true
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = Colors.clearBlue.cgColor
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
    private func fecthUsersCollection() {
           let firestoreService = FirestoreService<Profil>()
           firestoreService.fetchCollection(endpoint: .user) { [weak self] result in
               switch result {
               case .success(let users):
                   self?.allUsers = users.sorted {
                       $0.rank > $1.rank
                   }
                   self?.fellows.removeAll()
                   for user in users {
                       if user.school == self?.userSchool {
                           self?.fellows.append(user)
                           self?.fellows.sort {
                               $0.rank > $1.rank
                           }
                       }
                   }
                   print(self?.userSchool as Any)
                   print(self?.fellows.count as Any)
                   self?.setRank()
                   self?.setSchoolRank()
               case .failure(let error):
                   print(error.localizedDescription)
                   self?.presentAlert(with: "Erreur réseau")
               }
           }
       }

    
    private func setRank() {
        for (index, user) in allUsers.enumerated() {
            if user.identifier == userID {
                if (index + 1) == 1 {
                    generalRank.text =  "\(index + 1)er"
                } else {
                    generalRank.text = "\(index + 1)ème"
                }
            }
        }
    }
    
    private func setSchoolRank() {
        for (index, user) in fellows.enumerated() {
            if user.identifier == userID {
                if (index + 1) == 1 {
                    schoolRank.text =  "\(index + 1)er"
                } else {
                    schoolRank.text = "\(index + 1)ème"
                }
            }
        }
    }
}
