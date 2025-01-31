//
//  Profil.swift
//  LawQuizz
//
//  Created by MacBook DS on 04/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import Foundation

struct Profil: Equatable {
    let identifier: String
    let email: String
    let userName: String
    let imageURL: String
    let school: String
    let totalQuestions: Int
    let goodAnswers: Int
    let wrongAnswers: Int
    let rank: Double
    

    var dictionary: [String: Any] {
        return [
            "userId": identifier,
            "email": email,
            "userName": userName,
            "imageURL": imageURL,
            "school": school,
            "totalQuestions": totalQuestions,
            "goodAnswers": goodAnswers,
            "wrongAnswers": wrongAnswers,
            "rank": rank
        ]
    }
}

extension Profil: DocumentSerializableProtocol {
    init?(dictionary: [String: Any]) {
       guard let identifier = dictionary["userId"] as? String,
            let email = dictionary["email"] as? String,
            let userName = dictionary["userName"] as? String,
            let imageURL = dictionary["imageURL"] as? String,
            let school = dictionary["school"] as? String,
            let totalQuestions = dictionary["totalQuestions"] as? Int,
            let goodAnswers = dictionary["goodAnswers"] as? Int,
            let wrongAnswers = dictionary["wrongAnswers"] as? Int,
            let rank = dictionary["rank"] as? Double else {return nil}
        
        self.init(identifier: identifier, email: email, userName: userName, imageURL: imageURL, school: school, totalQuestions: totalQuestions, goodAnswers: goodAnswers, wrongAnswers: wrongAnswers, rank: rank)
    }
}

