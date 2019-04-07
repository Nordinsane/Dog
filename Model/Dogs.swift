//
//  Dog.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-07.
//  Copyright © 2019 kim. All rights reserved.
//

import Foundation
import UIKit

class Dogs {
    
    var list = [DogEntry]()
    
    var count : Int {
        return list.count
    }
    
    func addDog(dog: DogEntry) {
        list.append(dog)
    }
    
    func clearDog() {
        list.removeAll()
    }
    
    func deleteDog(index: Int){
        list.remove(at: index)
    }
    
    func entry(index: Int) -> DogEntry? {
        
        if index >= 0 && index <= list.count {
            return list[index]
        }
        
        return nil
    }
}
