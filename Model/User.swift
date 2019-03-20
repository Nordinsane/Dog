//
//  User.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-15.
//  Copyright © 2019 kim. All rights reserved.
//

import Foundation

class User {
    
    var cred: String
    
    init(cred: String) {
        self.cred = cred
    }
    
    func toAny() -> [String: Any] {
        return ["cred" : cred]
    }
}
