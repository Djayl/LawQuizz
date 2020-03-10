//
//  Endpoint.swift
//  LawQuizz
//
//  Created by MacBook DS on 04/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import Foundation

public enum Endpoint {
    case user
    case currentUser
    case score
    case school(schoolId: String)
    case schools
    case particularUser(userId: String)
    case question(category: String, questionId: String)
}

extension Endpoint {
    var userId: String {
        guard let currentUser = AuthService.getCurrentUser() else {
            return "unknown user"
        }
        return currentUser.uid
    }
    
    var path: String {
        switch self {
        case .user:
            return "users"
        case .currentUser:
            return "users/\(userId)"
        case .score:
            return "users/\(userId)/score"
        case let .school(schoolId):
            return "schools/\(schoolId)"
        case .schools:
            return "schools"
        case let .particularUser(userId):
            return "users/\(userId)"
        case let .question(category, questionId):
            return "questions/\(category)/questions/\(questionId)"
        }
    }
}
