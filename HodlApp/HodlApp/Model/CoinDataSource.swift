//
//  CoinDataSource.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 31.12.2022.
//

import Foundation


class CoinDataSource {
    
    private var coinArray: [Coin] = []
    private let baseUrl = "https://api.coingecko.com/api/v3/"
    var delegate : CoinDataDelegate?
    
    func getListOfCoins(id: String = "") {
        let session = URLSession.shared
        if let url = URL(string: "\(baseUrl)/coins/markets?vs_currency=usd&ids=\(id)&order=market_cap_desc&per_page=250&page=1&sparkline=false") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    self.coinArray = try! decoder.decode([Coin].self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.coinListLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getNumberOfCoins() -> Int {
        return coinArray.count
    }
    
    func getCoin (for index: Int) -> Coin? {
        guard index < coinArray.count else {
            return nil
        }
        return coinArray[index]
    }
    func getCoinArray() -> [Coin] {
        return coinArray
    }
}
