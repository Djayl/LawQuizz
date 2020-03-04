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
    case publicCollection
    case publicSpot(spotId: String)
    case favorite(spotId: String)
    case favoriteCollection
    case favoriteSpot(spotId: String)
    case particularUser(userId: String)
    case particularUserCollection(userId: String)
    case privateSpot(spotId: String)
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
        case .publicCollection:
            return "spots"
        case let .favorite(spotId):
            return "users/\(userId)/favorites/\(spotId)"
        case let .publicSpot(spotId):
            return "spots/\(spotId)"
        case .favoriteCollection:
            return "users/\(userId)/favorites"
        case let .favoriteSpot(spotId):
            return "users/\(userId)/favorites/\(spotId)"
        case let .particularUser(userId):
            return "users/\(userId)"
        case let .particularUserCollection(userId):
            return "users/\(userId)/spots"
        case let .privateSpot(spotId):
        return "users/\(userId)/spots/\(spotId)"
        case let .question(category, questionId):
            return "questions/\(category)/questions/\(questionId)"
        }
    }
}
