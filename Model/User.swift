//
//  User.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-15.
//  Copyright © 2019 kim. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    let uid: String
    let email: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
