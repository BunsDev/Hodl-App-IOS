//
//  ExchangesViewController.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import UIKit

class ExchangesViewController: UIViewController {

    private let exchangeDataSource = ExchangeDataSource()
    private let coinDataSOurce = CoinDataSource()

    @IBOutlet weak var exchangeTableView: UITableView!
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Exchanges"
        exchangeDataSource.delegate = self
        coinDataSOurce.delegate = self
        exchangeDataSource.getListOfExchanges()
        coinDataSOurce.getListOfCoins(id: "bitcoin")
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if
            let cell = sender as? ExchangeTableViewCell,
            let indexPath = exchangeTableView.indexPath(for: cell),
            let exchange = exchangeDataSource.getExchange(for: indexPath.row),
            let exchangeDetailController = segue.destination as? ExchangeDetailViewController {
            exchangeDetailController.exchangeId = exchange.id
        }
    }
}

extension ExchangesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exchangeDataSource.getNumberOfExchanges()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =
                tableView
                .dequeueReusableCell(withIdentifier: "ExchangeTableCell") as? ExchangeTableViewCell
    
        else {
            return UITableViewCell()
        }
        
        if let exchange = exchangeDataSource.getExchange(for: indexPath.row) {
            
            
            if let imageUrl = exchange.image {
                
                if let url = URL(string: imageUrl) {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async {
                            cell.exchangeImageView.image = UIImage(data: data)
                        }
                    }
                    task.resume()
                }
            }
            
            else {
                cell.exchangeImageView.image = UIImage()
            }
            
            if let coin = coinDataSOurce.getCoin(for: 0) {
                
                if let tradeVolumeBtc24h = exchange.trade_volume_24h_btc {
                    cell.exchangeVolumeBtc24hLabel.text = (tradeVolumeBtc24h * coin.current_price).formatted(.currency(code: "USD"))
                }
                else {
                    cell.exchangeVolumeBtc24hLabel.text = "NA"
                }
            }
            else {
                cell.exchangeVolumeBtc24hLabel.text = "NA"
            }
            
            cell.exchangeNameLabel.text = exchange.name
            
            if let turstScoreRank = exchange.trust_score_rank {
                cell.exchangeTrustScoreRankLabel.text = "#\(turstScoreRank)"
            }
            else {
                cell.exchangeTrustScoreRankLabel.text = "NA"
            }
            if let trustScore = exchange.trust_score {
                cell.exchangeTrustScoreLabel.text = "\(trustScore)"
            }
            else {
                cell.exchangeTrustScoreLabel.text = "NA"
            }
            
        }
        else {
            cell.exchangeNameLabel.text = "NA"
            cell.exchangeVolumeBtc24hLabel.text = "NA"
            cell.exchangeTrustScoreRankLabel.text =  "NA"
            cell.exchangeTrustScoreLabel.text = "NA"
        }
        return cell
    }
}

extension ExchangesViewController: ExchangeDataDelegate {
    
    func exchangeListLoaded() {
        exchangeTableView.reloadData()
    }
}

extension ExchangesViewController: CoinDataDelegate {
    func coinListLoaded() {
        exchangeTableView.reloadData()
    }
}


