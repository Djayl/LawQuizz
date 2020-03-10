//
//  GeneralRankingViewController.swift
//  LawQuizz
//
//  Created by MacBook DS on 10/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class GeneralRankingViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
       var users = [Profil]()
       var userID = ""
       var userSchool = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "SpartanMB-Bold", size: 20)!]
        self.navigationItem.title = "Classement général"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        tableView.reloadData()
        tableView.register(UINib(nibName: "RankingCell", bundle: nil),forCellReuseIdentifier: "RankingCell")
    }
    
    fileprivate func setUpTableView() {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.layoutMargins = UIEdgeInsets.zero
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.tableFooterView = UIView()
        }

}

@available(iOS 13.0, *)
extension GeneralRankingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection    section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell") as? RankingCell {
            
            cell.configureCell(user: users[indexPath.row])
                cell.userRankLabel.textColor = Colors.clearBlue
            if users[indexPath.row].identifier == userID {
                cell.usernameLabel.textColor = Colors.orange
                cell.userRankLabel.textColor = Colors.orange
                cell.schoolUserLabel.textColor = Colors.orange
            }
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
            
            
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
    
}
