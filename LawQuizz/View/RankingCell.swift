//
//  RankingCell.swift
//  LawQuizz
//
//  Created by MacBook DS on 08/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import UIKit
import Kingfisher

class RankingCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var schoolUserLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(user: Profil) {
        usernameLabel.text = user.userName.capitalized
        schoolUserLabel.text = user.school
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        
        getImage(user)
    }
    
    private func getImage(_ user: Profil) {
        let urlString = user.imageURL
        guard let url = URL(string: urlString) else {return}
        KingfisherManager.shared.retrieveImage(with: url, options: nil) { result in
            let image = try? result.get().image
            if let image = image {
                self.profileImageView.image = image
            }
        }
    }
    
}
