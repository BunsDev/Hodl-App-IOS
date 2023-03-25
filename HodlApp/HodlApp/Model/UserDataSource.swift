//
//  UserDataSource.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 2.01.2023.
//

import Foundation

class UserDataSource {
    
    var user = User(name: "Sinan Cem", surname: "Erdoğan", password: "1234", portfolio: ["bitcoin":0.1, "ethereum": 0.25, "okb":10.0, "binancecoin":2.0, "mina-protocol":500.0])
    var delegate : UserDataDelegate?
    
    func getUser() {
        
        DispatchQueue.main.async {
            self.delegate?.userLoaded()
        }
    }
    
    func get() -> User {
        return self.user
    }
    
    func getNumberOfAssets() -> Int {
        return self.user.portfolio.count
    }
    
    func updatePortfolio(id: String, amount:Double, isSell:Bool) {
        
        if let oldValue = self.user.portfolio[id] {
            
            if(isSell) {
                self.user.portfolio.updateValue(oldValue - amount, forKey: id)
            }
            else {
                self.user.portfolio.updateValue(oldValue + amount, forKey: id)
            }
            
        }
        else {
            
            if(!isSell) {
                self.user.portfolio.updateValue(amount, forKey: id)
            }
        }
    }
}
