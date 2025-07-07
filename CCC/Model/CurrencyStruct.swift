//
//  CurrencyResult.swift
//  CCC
//
//  Created by luca on 7/7/25.
//

import Foundation

struct CurrencyStruct: Codable {
  // ex: "success"
  let result: String
  // ex: "Mon, 07 Jul 2025 00:02:32 +0000"
//  let timeLastUpdate: String
  // ex: "Tue, 08 Jul 2025 00:14:22 +0000"
//  let timeNextUpdate: String
  let rates: [String: Double]

  enum CodingKeys: String, CodingKey {
    case result
    static let timeLastUpdate = "time_last_update_utc"
    static let timeNextUpdate = "time_next_update_utc"
    case rates
  }
}

//
// struct CurrencyRates: Codable {
//  // "USD": 1,
//  // "AED": 3.6725,
//  // ...
//  let rates: [String: Double]
// }
