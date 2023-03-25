//
//  TransactionViewController.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 3.01.2023.
//

import UIKit

class TransactionListViewController: UIViewController, UISearchBarDelegate {

    private let coinDataSource = CoinDataSource()
    
    private let userDataSource = UserDataSource()
    
    @IBOutlet weak var coinTransactionTableView: UITableView!
    
    @IBOutlet weak var coinSearchBar: UISearchBar!
    
    var data: [Coin] = []
    var filteredData: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Coins"
        coinDataSource.delegate = self
        coinDataSource.getListOfCoins()
        coinSearchBar.delegate = self
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TransactionListViewController.dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    override func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if
            let cell = sender as? CoinTransactionTableViewCell,
            let indexPath = coinTransactionTableView.indexPath(for: cell),
            let transactionController = segue.destination as? TransactionViewController {
            let coin = filteredData[indexPath.row]
            transactionController.coinId = coin.id
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                
        if searchText == "" {
            filteredData = data
        }
        else {
            filteredData.removeAll()
            for coin in coinDataSource.getCoinArray() {
                if coin.name.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(coin)
                }
            }
        }
        coinTransactionTableView.reloadData()
    }
}
extension TransactionListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =
            tableView
            .dequeueReusableCell(withIdentifier: "CoinTransactionTableCell") as?  CoinTransactionTableViewCell
                
        else {
            return UITableViewCell()
        }
        
        let coin = filteredData[indexPath.row]
            cell.coinNameLabel.text = coin.name
        
        return cell
    }
    
}

extension TransactionListViewController: CoinDataDelegate {

    func coinListLoaded() {
        data = coinDataSource.getCoinArray()
        filteredData = data
        coinTransactionTableView.reloadData()
    }
}
