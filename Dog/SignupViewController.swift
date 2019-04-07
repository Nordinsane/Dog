//
//  SignupViewController.swift
//  Hund
//
//  Created by Kim Nordin on 2019-02-21.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    
    var userEmail: String = ""
    var userPassword: String = ""
    var userPasswordConfirm: String = ""
    var db: Firestore!
    var users =  [User]()

    @IBAction func signUpAction(_ sender: UIButton) {
        if passwordField.text != passwordConfirmField.text {
            let alertController = UIAlertController(title: "Fel Lösenord", message: "Skriv ditt Lösenord igen", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!){ (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
                    
                    let mail = self.emailField.text
                    
                    let dbase = Firestore.firestore()
                    
//                    let email = User(cred: mail ?? "")
//                    dbase.collection("users").addDocument(data: email.toAny())
//                    print(email)
                    print(mail)
//                    let majs = Item(name: "Majs")
//                    self.db.collection("items").addDocument(data: majs.toAny())
//                    itemsRef.addDocument(data: userEmail)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.isSecureTextEntry = true
        passwordConfirmField.isSecureTextEntry = true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "signUpSegue" {
                return false
        }
        return true
    }
}
