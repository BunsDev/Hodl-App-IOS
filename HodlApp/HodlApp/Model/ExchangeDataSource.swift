//
//  ExchangeDataSource.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import Foundation

class ExchangeDataSource {
    
    private var exchangeArray: [Exchange] = []
    private var exchange: Exchange = Exchange(id: "", name: "", year_established: 0, country: "", description: "", url: "", image: "", has_trading_incetive: false, trust_score: 0, trust_score_rank: 0, trade_volume_24h_btc: 0.0, trade_volume_24h_btc_normalized: 0.0)
    private let baseUrl = "https://api.coingecko.com/api/v3/"
    var delegate : ExchangeDataDelegate?
    
    func getListOfExchanges() {
        let session = URLSession.shared
        if let url = URL(string: "\(baseUrl)/exchanges") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    self.exchangeArray = try! decoder.decode([Exchange].self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.exchangeListLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getExchange(id: String) {
        let session = URLSession.shared
        if let url = URL(string: "\(baseUrl)/exchanges/\(id)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    self.exchange = try! decoder.decode(Exchange.self, from: data)
                    DispatchQueue.main.async {
                        self.delegate?.exchangeListLoaded()
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getNumberOfExchanges() -> Int {
        return exchangeArray.count
    }
    
    func getExchange (for index: Int) -> Exchange? {
        guard index < exchangeArray.count else {
            return nil
        }
        return exchangeArray[index]
    }
    func getExchange() -> Exchange? {
            return exchange
    }
}
