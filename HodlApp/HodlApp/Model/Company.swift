//
//  Company.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import Foundation

struct Company: Decodable {
    
    let name: String
    let symbol: String
    let country: String
    let total_holdings: Int
    let total_entry_value_usd: Int
    let total_current_value_usd: Int
    let percentage_of_total_supply: Double
    
}
