//
//  Exchange.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import Foundation

struct Exchange: Decodable {
    
    let id: String?
    let name: String
    let year_established: Int?
    let country: String?
    let description: String?
    let url: String?
    let image: String?
    let has_trading_incetive: Bool?
    let trust_score: Int?
    let trust_score_rank: Int?
    let trade_volume_24h_btc: Double?
    let trade_volume_24h_btc_normalized: Double?

}

