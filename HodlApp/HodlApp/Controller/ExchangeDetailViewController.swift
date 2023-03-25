//
//  ExchangeDetailViewController.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import UIKit

class ExchangeDetailViewController: UIViewController {
    
    var exchangeId: String?
    
    private let exchangeDataSource = ExchangeDataSource()
    
    private let coinDataSOurce = CoinDataSource()

    @IBOutlet weak var exchangeImageView: UIImageView!
    
    @IBOutlet weak var exchangeNameLabel: UILabel!
    
    @IBOutlet weak var exchangeVolume24hLabel: UILabel!
    
    @IBOutlet weak var exchangeTrustScoreRank: UILabel!
    
    @IBOutlet weak var exchangeTrustScoreLabel: UILabel!
    
    @IBOutlet weak var exchangeYearEstablishedLabel: UILabel!
    
    @IBOutlet weak var exchangeCountryLabel: UILabel!
    
    @IBOutlet weak var exchangeUrlLabel: UILabel!
    
    @IBOutlet weak var exchangeDescriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        exchangeDataSource.delegate = self
        coinDataSOurce.delegate = self
        
        if let exchangeId = exchangeId {
            exchangeDataSource.getExchange(id: exchangeId)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func urlLabelTapped(sender:UITapGestureRecognizer) {
        let labeltext = exchangeUrlLabel.text
        UIPasteboard.general.string = labeltext
        let alert = UIAlertController(title:"", message: "Copied", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async {
        self.present(alert, animated: true, completion: nil)
            }
    }
}

extension ExchangeDetailViewController: ExchangeDataDelegate {
    func exchangeListLoaded() {
        
        coinDataSOurce.getListOfCoins(id: "bitcoin")
    }
}

extension ExchangeDetailViewController: CoinDataDelegate {
    func coinListLoaded() {
        
        if let exchange = exchangeDataSource.getExchange() {
            
            self.title = exchange.name
            
            if let imageUrl = exchange.image {
                if let url = URL(string: imageUrl) {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async {
                            self.exchangeImageView.image = UIImage(data: data)
                        }
                    }
                    task.resume()
                }
            }
            
            self.title = exchange.name
            
            exchangeNameLabel.text = exchange.name
            
            if let coin = coinDataSOurce.getCoin(for: 0) {
                if let tradeVolumeBtc24h = exchange.trade_volume_24h_btc {
                    exchangeVolume24hLabel.text = (tradeVolumeBtc24h * coin.current_price).formatted(.currency(code: "USD"))
                }
                else {
                    exchangeVolume24hLabel.text = "NA"
                }
            }
            else {
                exchangeVolume24hLabel.text = "NA"
            }
            if let trustScoreRank = exchange.trust_score_rank {
                exchangeTrustScoreRank.text = "#\(trustScoreRank)"
            }
            else {
                exchangeTrustScoreRank.text = "NA"
            }
            if let trustScore = exchange.trust_score {
                exchangeTrustScoreLabel.text = "\(trustScore)"
            }
            else {
                exchangeTrustScoreLabel.text = "NA"
            }
            if let yearEstablished = exchange.year_established {
                exchangeYearEstablishedLabel.text = "\(yearEstablished)"
            }
            else {
                exchangeYearEstablishedLabel.text = "NA"
            }
            if let exchangeCountry = exchange.country {
                exchangeCountryLabel.text = exchangeCountry
            }
            else {
                exchangeCountryLabel.text = "NA"
            }
            if let exchangeUrl = exchange.url {
                exchangeUrlLabel.text = exchangeUrl
                exchangeUrlLabel.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(urlLabelTapped))
                tap.numberOfTapsRequired = 1
                exchangeUrlLabel.addGestureRecognizer(tap)
            }
            else {
                exchangeUrlLabel.text = "NA"
            }
            if let exchangeDescription = exchange.description {
                exchangeDescriptionTextView.text = exchangeDescription
            }
            else {
                exchangeDescriptionTextView.text = "NA"
            }
        }
        else {
            exchangeImageView.image = UIImage()
            exchangeNameLabel.text = "NA"
            exchangeVolume24hLabel.text = "NA"
            exchangeTrustScoreRank.text = "NA"
            exchangeTrustScoreLabel.text = "NA"
            exchangeYearEstablishedLabel.text = "NA"
            exchangeCountryLabel.text = "NA"
            exchangeUrlLabel.text = "NA"
            exchangeDescriptionTextView.text = "NA"
        }
    }
}
