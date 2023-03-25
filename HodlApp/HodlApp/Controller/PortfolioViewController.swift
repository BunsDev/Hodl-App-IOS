//
//  PortfolioViewController.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import Charts
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class PortfolioViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var porfolioTableView: UITableView!
    
    @IBOutlet weak var addTransactionButton: UIButton!
    
    private let coinDataSource = CoinDataSource()
    
    private let portfolioDataSource = PortfolioDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Portfolio"
        pieChartView.delegate = self
        coinDataSource.delegate = self
        portfolioDataSource.delegate = self
        portfolioDataSource.getPortfolio()
        pieChartView.usePercentValuesEnabled = true
        pieChartView.noDataText = "Start your portfolio by adding new transactions."
        pieChartView.noDataFont = UIFont.systemFont(ofSize: 13)
        pieChartView.noDataTextColor = UIColor.white
        
        addTransactionButton.layer.cornerRadius = 10
        addTransactionButton.layer.borderWidth = 1
        addTransactionButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if
            let cell = sender as? PortfolioTableViewCell,
            let indexPath = porfolioTableView.indexPath(for: cell),
            let coin = coinDataSource.getCoin(for: indexPath.row),
            let transactionController = segue.destination as? TransactionViewController {
            transactionController.coinId = coin.id
        }
    }
}

extension PortfolioViewController: CoinDataDelegate {
    
    func coinListLoaded() {
    
        var entries = [ChartDataEntry]()
        var sum = 0.0
        
        for i in 0...coinDataSource.getNumberOfCoins() - 1 {
            
            if let coin = coinDataSource.getCoin(for: i),
               let amount = portfolioDataSource.getAmount(for: coin.id) {
                let x = coin.current_price * amount
                entries.append(PieChartDataEntry(value: x , label: coin.name))
                sum += coin.current_price * amount
            }
        }
        let set = PieChartDataSet(entries: entries, label: "")
        set.colors = ChartColorTemplates.pastel()
        set.colors.append(contentsOf: ChartColorTemplates.colorful())
        set.colors.append(contentsOf: ChartColorTemplates.joyful())
        set.colors.append(contentsOf: ChartColorTemplates.material())
        
        let sumAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.white,  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13) ]
        let sumAttributed = NSAttributedString(string: sum.formatted(.currency(code: "USD")), attributes: sumAttribute)
    
        pieChartView.holeColor = UIColor.black
        pieChartView.legend.textColor = UIColor.white
        pieChartView.usePercentValuesEnabled = false
        pieChartView.centerAttributedText = sumAttributed
        let data = PieChartData(dataSet: set)
        pieChartView.data = data
        porfolioTableView.reloadData()
    }
}

extension PortfolioViewController: PortfolioDataDelegate {
    func portfolioLoaded() {
        portfolioDataSource.cleanUpPortfolio()
        
        if let coinIds = portfolioDataSource.getCoinIds() {
            coinDataSource.getListOfCoins(id: coinIds)
        }
    }
}

extension PortfolioViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinDataSource.getNumberOfCoins()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =
            tableView
            .dequeueReusableCell(withIdentifier: "PortfolioTableCell") as? PortfolioTableViewCell
                
        else {
            return UITableViewCell()
        }
        
        if let coin = coinDataSource.getCoin(for: indexPath.row),
           let amount = portfolioDataSource.getAmount(for: coin.id) {
            
            cell.coinNameLabel.text = coin.name
            cell.coinAmountLabel.text = amount.formatted(.number)
            cell.coinValueInUsdLabel.text = (coin.current_price * amount).formatted(.currency(code: "USD"))
            
        }
        else {
            
            cell.coinNameLabel.text = "NA"
            cell.coinAmountLabel.text = "NA"
            cell.coinValueInUsdLabel.text = "NA"
            
        }
        return cell
    }
}
