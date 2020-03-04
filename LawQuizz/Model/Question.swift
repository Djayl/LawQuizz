//
//  Question.swift
//  LawQuizz
//
//  Created by MacBook DS on 04/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import Foundation

struct Question: Equatable {
    
    let question: String
    let answer1: String
    let answer2: String
    let answer3: String
    let answer4: String
    let goodAnswer: String
    
    

    var dictionary: [String: Any] {
        return [
            "question": question,
            "answer1": answer1,
            "answer2": answer2,
            "answer3": answer3,
            "answer4": answer4,
            "goodAnswer": goodAnswer
        ]
    }
}

extension Question: DocumentSerializableProtocol {
    init?(dictionary: [String: Any]) {
        guard let question = dictionary["question"] as? String,
            let answer1 = dictionary["answer1"] as? String,
            let answer2 = dictionary["answer2"] as? String,
            let answer3 = dictionary["answer3"] as? String,
            let answer4 = dictionary["answer4"] as? String,
            let goodAnswer = dictionary["goodAnswer"] as? String else {return nil}
       
        self.init(question: question, answer1: answer1, answer2: answer2, answer3: answer3, answer4: answer4, goodAnswer: goodAnswer)
    }
    
}
