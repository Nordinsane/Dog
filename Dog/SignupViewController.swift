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
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    
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
        
        
        emailField.attributedPlaceholder = NSAttributedString(string: "E-Mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 0.45)])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 0.45)])
        passwordConfirmField.attributedPlaceholder = NSAttributedString(string: "Re- Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 0.45)])
        
        signUpButton.backgroundColor = UIColor(red: 255/255, green: 116/255, blue: 0/255, alpha: 0.8)
        emailField.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        passwordField.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        passwordConfirmField.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)

        emailField.layer.cornerRadius = 20
        passwordField.layer.cornerRadius = 20
        passwordConfirmField.layer.cornerRadius = 20
        passwordField.isSecureTextEntry = true
        passwordConfirmField.isSecureTextEntry = true
        signUpButton.layer.cornerRadius = 30
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "signUpSegue" {
                return false
        }
        return true
    }
}
