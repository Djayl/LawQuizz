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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var topView: UIView!
    
    
    var users = [Profil]()
    var schools = [School]()
    var allusers = [String]()
    var userID = ""
    var userSchool = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "SpartanMB-Bold", size: 20)!]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        tableView.reloadData()
        fecthUsersCollection()
        tableView.register(UINib(nibName: "RankingCell", bundle: nil),forCellReuseIdentifier: "RankingCell")
    }
    
    @IBAction func didChooseData(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Tag 0")
            print(users.count)
            tableView.reloadData()
        case 1:
            print("Tag 1")
            fecthUsersCollection()
            print(schools as Any)
            tableView.reloadData()
        default:
            break
        }
    }
    
    fileprivate func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
//        tableView.backgroundColor = UIColor.white
    }
        
    private func fecthUsersCollection() {
        let firestoreService = FirestoreService<School>()
        
        firestoreService.fetchCollection(endpoint: .schools) { [weak self] result in
            switch result {
            case .success(let schools):
                self?.schools.removeAll()
                self?.schools = schools
                self?.schools.sort {
                    $0.goodAnswers > $1.goodAnswers
                }
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
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
            if segmentedControl.selectedSegmentIndex == 0 {
            cell.configureCell(user: users[indexPath.row])
                cell.userRankLabel.textColor = Colors.clearBlue
            if users[indexPath.row].identifier == userID {
                cell.usernameLabel.textColor = Colors.orange
                cell.userRankLabel.textColor = Colors.orange
                cell.schoolUserLabel.textColor = Colors.orange
            }
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
            
            } else {
                cell.configureCellWithSchool(school: schools[indexPath.row])
                cell.userRankLabel.textColor = Colors.clearBlue
                if schools[indexPath.row].name == userSchool {
                    cell.schoolName.textColor = Colors.orange
                    cell.userRankLabel.textColor = Colors.orange
                }
            }
            if ((indexPath.row) + 1) == 1 {
                cell.userRankLabel.text = "\((indexPath.row) + 1)er"
            } else {
                cell.userRankLabel.text = "\((indexPath.row) + 1)ème"
            }
            cell.clipsToBounds = true
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if users[indexPath.row].identifier == userID {
//            cell.tintColor = Colors.clearBlue
//        }
//    }
}
