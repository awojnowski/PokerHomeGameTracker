//
//  Transaction.swift
//  PokerHomeGameTracker
//
//  Created by Aaron Wojnowski on 2019-11-30.
//  Copyright © 2019 Aaron Wojnowski. All rights reserved.
//

import Foundation

enum TransactionType {
    case buyin
    case cashout
}

extension TransactionType: Codable {
    enum Key: CodingKey {
        case typeName
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .typeName)
        switch rawValue {
        case "buyin":
            self = .buyin
        case "cashout":
            self = .cashout
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .buyin:
            try container.encode("buyin", forKey: .typeName)
        case .cashout:
            try container.encode("cashout", forKey: .typeName)
        }
    }
}

struct Transaction: Codable {
    var name: String
    var date: Date
    var total: Int
    var type: TransactionType
}
