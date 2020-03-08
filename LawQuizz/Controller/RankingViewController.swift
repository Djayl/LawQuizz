//
//  RankingViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 08/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class RankingViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var users = [Profil]()
    var allusers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fecthUsersCollection()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "SpartanMB-Bold", size: 21)!]
        self.navigationItem.title = "Classement général"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.register(UINib(nibName: "RankingCell", bundle: nil),forCellReuseIdentifier: "RankingCell")
    }
    
    fileprivate func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.white
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        users.removeAll()
    //    }
    
    //    private func getUserData(_ profil: Profil) {
    //
    //        for item in allusers {
    ////            if item == profil.identifier {
    //                let id = item
    //                let email = profil.email
    //                let userName = profil.userName
    //                let imageURL = profil.imageURL
    //                let school = profil.school
    //                let totalQuestions = profil.totalQuestions
    //                let goodAnswers = profil.goodAnswers
    //                let wrongAnswers = profil.wrongAnswers
    //
    //                let user = Profil(identifier: id, email: email, userName: userName, imageURL: imageURL, school: school, totalQuestions: totalQuestions, goodAnswers: goodAnswers, wrongAnswers: wrongAnswers)
    //
    //                users.append(user)
    //                print(user.userName)
    //            }
    //        tableView.reloadData()
    //
    ////        }
    //    }
    
    private func fecthUsersCollection() {
        let firestoreService = FirestoreService<Profil>()
        
        firestoreService.fetchCollection(endpoint: .user) { [weak self] result in
            switch result {
            case .success(let users):
                self?.users.removeAll()
                self?.users = users.sorted {
                    $0.rank > $1.rank
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.presentAlert(with: "Erreur réseau")
            }
        }
    }
    
}

@available(iOS 13.0, *)
extension RankingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection    section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell") as? RankingCell {
            cell.configureCell(user: users[indexPath.row])
            cell.clipsToBounds = true
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
            if ((indexPath.row) + 1) == 1 {
                cell.userRankLabel.text = "\((indexPath.row) + 1)er"
            } else {
                cell.userRankLabel.text = "\((indexPath.row) + 1)ème"
            }
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        }
        return UITableViewCell()
    }
}
