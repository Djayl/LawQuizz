//
//  DocumentSerializableProtocol.swift
//  LawQuizz
//
//  Created by MacBook DS on 04/03/2020.
//  Copyright © 2020 Djilali Sakkar. All rights reserved.
//

import Foundation

public protocol DocumentSerializableProtocol {
    init?(dictionary: [String: Any])
}
