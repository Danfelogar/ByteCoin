//
//  CoinData.swift
//  ByteCoin
//
//  Created by Daniel Felipe on 17/09/23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
