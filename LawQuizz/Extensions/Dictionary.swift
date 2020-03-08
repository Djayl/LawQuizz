//
//  Dictionary.swift
//  LawQuizz
//
//  Created by MacBook DS on 08/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import Foundation

extension Dictionary {
    subscript(i:Int)-> (key: Key, value: Value) {
        get {
            return self[index(startIndex,offsetBy: i)];
        }
    }
}
