//
//  MainScreenViewController.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 31.12.2022.
//

import UIKit
import FirebaseAuth

class MainScreenViewController: UIViewController {
    
   private let coinDataSource = CoinDataSource()
    
    @IBOutlet weak var coinTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coinDataSource.delegate = self
        coinDataSource.getListOfCoins()
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        
        print("Tapped")
        do
        {
             try Auth.auth().signOut()
             let entryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "EntryViewController")
            
             if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
                let window = sceneDelegate.window
                window?.rootViewController = entryViewController
            }
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if
            let cell = sender as? CoinTableViewCell,
            let indexPath = coinTableView.indexPath(for: cell),
            let coin = coinDataSource.getCoin(for: indexPath.row),
            let coinDetailController = segue.destination as? CoinDetailViewController {
            coinDetailController.coinId = coin.id
        }
    }
}

extension MainScreenViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coinDataSource.getNumberOfCoins()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =
            tableView
            .dequeueReusableCell(withIdentifier: "CoinTableCell") as? CoinTableViewCell
                
        else {
            return UITableViewCell()
        }
        if let coin = coinDataSource.getCoin(for: indexPath.row) {
            
            if let url = URL(string: coin.image) {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async {
                        cell.coinImageView.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
            
            cell.coinSymbolLabel.text = coin.symbol.uppercased()
            cell.coinPriceLabel.text = coin.current_price.formatted(.currency(code: "USD"))
            cell.coinNameLabel.text = coin.name
            if let priceChange24h = coin.price_change_percentage_24h {
                cell.coinPercentageChange24hLabel.text = "\(String(format: "%.2f", priceChange24h))%"
                if(priceChange24h < 0) {
                    cell.coinPercentageChange24hLabel.textColor = UIColor.red
                }
                else {
                    cell.coinPercentageChange24hLabel.textColor = UIColor.green
                }
            }
            else {
                cell.coinPercentageChange24hLabel.text = "NA"
            }
            
        }
        else {
            cell.coinSymbolLabel.text = "NA"
            cell.coinPriceLabel.text = "NA"
            cell.coinPercentageChange24hLabel.text = "NA"
        }
        return cell
    }
    
}

extension MainScreenViewController: CoinDataDelegate {
    
    func coinListLoaded() {
        coinTableView.reloadData()
    }
}

