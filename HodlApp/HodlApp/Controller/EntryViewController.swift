//
//  EntryViewController.swift
//  HodlApp
//
//  Created by Sinan Cem Erdoğan on 4.01.2023.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class EntryViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "dolar")!)
        
        if Auth.auth().currentUser != nil {
            let mainTabController = self.storyboard?.instantiateViewController(identifier: "MainTabBarController") as! MainTabBarController
            self.present(mainTabController, animated: false)
        }
        errorLabel.alpha = 0
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TransactionListViewController.dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        
        let errorMessage = validateFields()
        
        if errorMessage != nil {
            errorLabel.text = errorMessage
            errorLabel.alpha = 1
            return
        }
        
        if errorMessage != nil {
            errorLabel.text = errorMessage
            errorLabel.alpha = 1
        }
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                let mainTabController = self.storyboard?.instantiateViewController(identifier: "MainTabBarController") as! MainTabBarController
                self.present(mainTabController, animated: true)
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        let errorMessage = validateFields()
        
        if errorMessage != nil {
            errorLabel.text = errorMessage
            errorLabel.alpha = 1
        }
        
        else {
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    
                    // There was an error creating the user
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else {
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(result!.user.uid).setData([:]) { (error) in
                        
                        if error != nil {
                            self.errorLabel.text = "Error saving user data"
                            self.errorLabel.alpha = 1
                        }
                        else {
                            let mainTabController = self.storyboard?.instantiateViewController(identifier: "MainTabBarController") as! MainTabBarController
                            self.present(mainTabController, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func validateFields() -> String? {
        if
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        return nil
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
extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
