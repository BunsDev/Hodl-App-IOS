//
//  PortfolioDataSource.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 4.01.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class PortfolioDataSource {
    
    private var portfolio: [String: Any] = [:]
    var delegate: PortfolioDataDelegate?
    
    func getPortfolio() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
          }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { snapshot, error in
            
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                
                if (snapshot != nil && snapshot!.exists) {
                    
                    if let data = snapshot!.data() {
                        self.portfolio = data
                        
                        DispatchQueue.main.async {
                            self.delegate?.portfolioLoaded()
                        }
                    }
                }
            }
        }
    }
    
    func getCoinIds() -> String? {
        
        if portfolio.keys.joined(separator: ",") == "" {
            return nil
        }
        return portfolio.keys.joined(separator: ",")
    }
    
    func getAmount(for key: String) -> Double? {
        return portfolio[key] as? Double
    }
    func getNumberOfAssests() -> Int {
        return portfolio.keys.count
    }
    
    func updatePortfolio(coinID: String, amount:Double, isBuy:Bool) ->String? {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return "Error while getting user id!"
          }
        let db = Firestore.firestore()
        var error = "Success"
        
        if(isBuy) {
            
            if(portfolio[coinID] == nil) {
                
                portfolio[coinID] = amount
            }
            else {
                
                if
                   let oldAmount = portfolio[coinID] as? Double {
                    portfolio[coinID] = oldAmount + amount
                }
            }
        }
        
        else {
            
            if(portfolio[coinID] == nil) {
                
                error =  "You don't have \(coinID) to sell."
            }
            
            else {
                
                if let oldAmount = portfolio[coinID] as? Double {
                    
                    if(oldAmount < amount) {
                        error =  "You cannot sell \(amount) \(coinID). You have \(oldAmount)!"
                    }
                    else {
                        portfolio[coinID] = oldAmount - amount
                    }
                }
            }
        }
        db.collection("users").document(uid).setData(portfolio, merge: false) { err in
            if err != nil {
                error = err!.localizedDescription
            }
        }
        return error
    }
    
     func cleanUpPortfolio() {
        
        for key in portfolio.keys {
            
            if let value = portfolio[key] as? Double {
                if (value == 0.0) {
                    portfolio.removeValue(forKey: key)
                }
            }
        }
    }
}
