//
//  PublicTreasury.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import Foundation

struct PublicTreasury: Decodable {
    
    let total_holdings: Double
    let total_value_usd: Double
    let market_cap_dominance: Double
    var companies: [Company]
    
}
