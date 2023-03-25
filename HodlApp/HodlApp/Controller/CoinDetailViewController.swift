//
//  CoinDetailViewController.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 31.12.2022.
//

import UIKit

class CoinDetailViewController: UIViewController {

    private let coinaDataSource = CoinDataSource()
    
    var coinId: String?

    @IBOutlet weak var coinImageView: UIImageView!
    
    @IBOutlet weak var coinNameLabel: UILabel!
    
    @IBOutlet weak var coinSymbolLabel: UILabel!
    
    @IBOutlet weak var coinPriceLabel: UILabel!
    
    @IBOutlet weak var low24hLabel: UILabel!
    
    @IBOutlet weak var high24hLabel: UILabel!
    
    @IBOutlet weak var priceChange24hLabel: UILabel!
    
    @IBOutlet weak var priceChangePercentage24hLabel: UILabel!
    
    @IBOutlet weak var marketCapChangePercentage24hLabel: UILabel!
    
    @IBOutlet weak var totalVolumeLabel: UILabel!
    
    @IBOutlet weak var marketCapRankLabel: UILabel!
    
    @IBOutlet weak var marketCapLabel: UILabel!
    
    @IBOutlet weak var fullDilutedValuationLabel: UILabel!
    
    @IBOutlet weak var allTimeHighLabel: UILabel!
    
    @IBOutlet weak var circulatingSupplyLabel: UILabel!
    
    @IBOutlet weak var totalSupplyLabel: UILabel!
    
    @IBOutlet weak var maxSupplyLabel: UILabel!
    
    @IBOutlet weak var allTimeLowLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        coinaDataSource.delegate = self
        if let coinId = coinId {
            coinaDataSource.getListOfCoins(id: coinId)
        }
    }
    

    @IBOutlet weak var coinDetail24hStackView: UIStackView!
    
    @IBOutlet weak var marketStackView: UIStackView!
    
    @IBOutlet weak var supplyStackView: UIStackView!
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CoinDetailViewController: CoinDataDelegate {
    
    func coinListLoaded() {
        if let coin = coinaDataSource.getCoin(for: 0){
            
            
            if let url = URL(string: coin.image) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async {
                        self.coinImageView.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
            self.title = coin.symbol.uppercased()
            coinNameLabel.text = coin.name
            coinSymbolLabel.text = coin.symbol.uppercased()
            coinPriceLabel.text = "$\(String(coin.current_price))"
            
            
            if let low24h = coin.low_24h {
                low24hLabel.text = low24h.formatted(.currency(code: "USD"))
            }
            else {
                low24hLabel.text = "NA"
            }
            if let high24h = coin.high_24h {
                high24hLabel.text = high24h.formatted(.currency(code: "USD"))
            }
            else {
                high24hLabel.text = "NA"
            }
            if let priceChange24h = coin.price_change_24h {
                priceChange24hLabel.text = priceChange24h.formatted(.currency(code: "USD"))
            }
            else {
                priceChange24hLabel.text = "NA"
            }
            if let princeChangePercentange24h = coin.price_change_percentage_24h {
                priceChangePercentage24hLabel.text = "\(String(princeChangePercentange24h))%"
            }
            else {
                priceChangePercentage24hLabel.text = "NA"
            }
            if let marketCapChancePercentage24h = coin.market_cap_change_percentage_24h {
                marketCapChangePercentage24hLabel.text = "\(String(marketCapChancePercentage24h))%"
            }
            else {
                marketCapChangePercentage24hLabel.text = "NA"
            }
            if let totalVolume = coin.total_volume {
                totalVolumeLabel.text = totalVolume.formatted(.currency(code: "USD"))
            }
            else {
                totalVolumeLabel.text = "NA"
            }
            if let marketCapRank = coin.market_cap_rank {
                marketCapRankLabel.text = "#\(String(marketCapRank))"
            }
            else {
                marketCapRankLabel.text = "NA"
            }
            if let marketCap = coin.market_cap {
                marketCapLabel.text = marketCap.formatted(.currency(code: "USD"))
            }
            else {
                marketCapLabel.text = "NA"
            }
            if let fullyDilutedValuation = coin.fully_diluted_valuation {
                fullDilutedValuationLabel.text = fullyDilutedValuation.formatted(.currency(code: "USD"))
            }
            else {
                fullDilutedValuationLabel.text = "NA"
            }
            if let allTimeHigh = coin.ath {
                allTimeHighLabel.text = allTimeHigh.formatted(.currency(code: "USD"))
            }
            else {
                allTimeHighLabel.text = "NA"
            }
            if let allTimeLow = coin.atl {
                allTimeLowLabel.text = allTimeLow.formatted(.currency(code: "USD"))
            }
            else {
                allTimeLowLabel.text = "NA"
            }
            if let circulatingSupply = coin.circulating_supply {
                circulatingSupplyLabel.text = circulatingSupply.formatted(.number)
            }
            else {
                circulatingSupplyLabel.text = "NA"
            }
            if let totalSupply = coin.total_supply {
                totalSupplyLabel.text = totalSupply.formatted(.number)
            }
            else {
                totalSupplyLabel.text = "NA"
            }
            if let maxSupply = coin.max_supply {
                maxSupplyLabel.text = maxSupply.formatted(.number)
            }
            else {
                maxSupplyLabel.text = "NA"
            }
        }
    }
}
