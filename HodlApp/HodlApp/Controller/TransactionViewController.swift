//
//  TransactionViewController.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 3.01.2023.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class TransactionViewController: UIViewController {
    
    @IBOutlet weak var buySellSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    private let portfolioDataSource = PortfolioDataSource()
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var addTransactionButton: UIButton!
    
    var coinId: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let coinId = coinId {
            if coinId.count < 5 {
                self.title = coinId.uppercased()
            }
            else {
                self.title = coinId.capitalized
            }
        }
        addTransactionButton.isEnabled = false
        portfolioDataSource.delegate = self
        portfolioDataSource.getPortfolio()
        errorLabel.alpha = 0
        addTransactionButton.layer.cornerRadius = 10
        addTransactionButton.layer.borderWidth = 1
        addTransactionButton.layer.borderColor = UIColor.lightGray.cgColor
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TransactionListViewController.dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func addTransaction(_ sender: Any) {
        
        if let coinId = coinId,
           let amountText = amountTextField.text,
           let amount = Double(amountText) {
            if let error = portfolioDataSource.updatePortfolio(coinID: coinId, amount: amount, isBuy: buySellSegmentedControl.selectedSegmentIndex == 0) {
                errorLabel.text = error
                errorLabel.alpha = 1
            }
            amountTextField.text = ""
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
}

extension TransactionViewController: PortfolioDataDelegate {
    func portfolioLoaded() {
        addTransactionButton.isEnabled = true
    }
}
