//
//  Item.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-29.
//  Copyright © 2019 kim. All rights reserved.
//

import Foundation
import Firebase

class Item {
    
    var name: String
    var done: Bool
    
    init(name: String, done: Bool = false) {
        self.name = name
        self.done = done
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        name = snapshotValue["name"] as! String
        done = snapshotValue["done"] as! Bool
    }
    
    
    func switchDone() {
        done = !done
    }
    
    func toAny() -> [String: Any] {
        return ["name": name,
                "done": done]
    }
}
