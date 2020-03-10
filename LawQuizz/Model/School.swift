//
//  School.swift
//  LawQuizz
//
//  Created by MacBook DS on 10/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import Foundation

struct School: Equatable {
    
    let name: String
    let totalQuestions: Int
    let goodAnswers: Int
    let rank: Double
   
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "totalQuestions": totalQuestions,
            "goodAnswers": goodAnswers,
            "rank": rank
        ]
    }
}

extension School: DocumentSerializableProtocol {
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let totalQuestions = dictionary["totalQuestions"] as? Int,
            let goodAnswers = dictionary["goodAnswers"] as? Int,
            let rank = dictionary["rank"] as? Double else {return nil}
       
        self.init(name: name, totalQuestions: totalQuestions, goodAnswers: goodAnswers, rank: rank)
    }
    
}
