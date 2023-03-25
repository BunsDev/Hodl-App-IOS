//
//  PublicTreasuryDataSource.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import Foundation

class PublicTreasuryDataSource {
    
    private var publicTreasury: PublicTreasury = PublicTreasury(total_holdings: 0, total_value_usd: 0, market_cap_dominance:0, companies: [])
    private let baseUrl = "https://api.coingecko.com/api/v3/"
    var delegate : PublicTreasuryDataDelegate?
    
    func getPublicTreasuryData(id: String = "") {
        let session = URLSession.shared
        if let url = URL(string: "\(baseUrl)/companies/public_treasury/bitcoin") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    self.publicTreasury = try! decoder.decode(PublicTreasury.self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.publicTreasuryDataLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getNumberOfCompanies() -> Int {
        return publicTreasury.companies.count
    }
    
    func getCompany (for index: Int) -> Company? {
        guard index < publicTreasury.companies.count else {
            return nil
        }
        return publicTreasury.companies[index]
    }
    
}
    
