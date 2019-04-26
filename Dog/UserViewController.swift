//
//  UserViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-04-12.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController {
    
    var db: Firestore!
    var auth: Auth!
    var thisUser: User!

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userId = Auth.auth().currentUser?.email {
            userName.text = userId
        }
        else {
            print("darn")
        }
        userImage.layer.cornerRadius = userImage.frame.height/2
        // Do any additional setup after loading the view.
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
