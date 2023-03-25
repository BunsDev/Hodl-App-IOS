//
//  CompayDetailViewController.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import UIKit

class CompanyDetailViewController: UIViewController {

    private let publicTreasuryDataSource = PublicTreasuryDataSource()
    
    var companyIndex: Int?
    
    @IBOutlet weak var companyNameLabel: UILabel!
    
    @IBOutlet weak var companySymbolLabel: UILabel!
    
    @IBOutlet weak var companyCountryLabel: UILabel!
    
    @IBOutlet weak var companyTotalHoldingsLabel: UILabel!
    
    @IBOutlet weak var companyTotalEntryValueUsdLabel: UILabel!
    
    @IBOutlet weak var companyTotalCurrentValueUsdLabel: UILabel!
    
    @IBOutlet weak var companyPercentageOfTotalSupplyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        publicTreasuryDataSource.delegate = self
        publicTreasuryDataSource.getPublicTreasuryData()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CompanyDetailViewController: PublicTreasuryDataDelegate {
    func publicTreasuryDataLoaded() {
        
        if let companyIndex = self.companyIndex {
            
            if let company = publicTreasuryDataSource.getCompany(for: companyIndex) {
                
                companyNameLabel.text = company.name
                companySymbolLabel.text = company.symbol
                companyCountryLabel.text = company.country
                companyTotalHoldingsLabel.text = company.total_holdings.formatted(.number)
                companyTotalEntryValueUsdLabel.text = company.total_entry_value_usd.formatted(.currency(code: "USD"))
                companyTotalCurrentValueUsdLabel.text = company.total_current_value_usd.formatted(.currency(code: "USD"))
                companyPercentageOfTotalSupplyLabel.text = "\(company.percentage_of_total_supply)%"
                
            }
            else {
                
                companyNameLabel.text = "NA"
                companySymbolLabel.text = "NA"
                companyCountryLabel.text = "NA"
                companyTotalHoldingsLabel.text = "NA"
                companyTotalEntryValueUsdLabel.text = "NA"
                companyTotalCurrentValueUsdLabel.text = "NA"
                companyPercentageOfTotalSupplyLabel.text = "NA"
                
            }
        }
        else {
            
            companyNameLabel.text = "NA"
            companySymbolLabel.text = "NA"
            companyCountryLabel.text = "NA"
            companyTotalHoldingsLabel.text = "NA"
            companyTotalEntryValueUsdLabel.text = "NA"
            companyTotalCurrentValueUsdLabel.text = "NA"
            companyPercentageOfTotalSupplyLabel.text = "NA"
            
        }
    }
}
