//
//  CompaniesViewController.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import UIKit

class CompaniesViewController: UIViewController {
    
    private let publicTreasuryDataSource = PublicTreasuryDataSource()

    @IBOutlet weak var companyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Companies"
        publicTreasuryDataSource.delegate = self
        publicTreasuryDataSource.getPublicTreasuryData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if
            let cell = sender as? CompanyTableViewCell,
            let indexPath = companyTableView.indexPath(for: cell),
            let companyDetailController = segue.destination as? CompanyDetailViewController {
            companyDetailController.companyIndex = indexPath.row
        }
    }
}

extension CompaniesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicTreasuryDataSource.getNumberOfCompanies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =
                companyTableView
                .dequeueReusableCell(withIdentifier: "CompanyTableCell") as? CompanyTableViewCell
        else {
            return UITableViewCell()
        }
        if let company = publicTreasuryDataSource.getCompany(for: indexPath.row) {
            
            cell.companyNameLabel.text = company.name
            cell.companySymbolLabel.text = company.symbol
            
        }
        else {
            
            cell.companyNameLabel.text = "NA"
            cell.companySymbolLabel.text = "NA"
            
        }
        return cell
    }
    
    
}

extension CompaniesViewController: PublicTreasuryDataDelegate {
    
    func publicTreasuryDataLoaded() {
        companyTableView.reloadData()
    }
}
