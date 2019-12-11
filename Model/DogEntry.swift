//
//  DogEntry.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-10.
//  Copyright © 2019 kim. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class DogEntry {
    
    var name: String
    var image: String
    var firstTimer: String
    var secondTimer: String
    var walking: Bool = false
    var walkArray: [String]
    var distArray: [String]
    var shareId: String
    var shared: Bool
    var id: String = ""
 
    
    init(name: String, image: String, firstTimer: String, secondTimer: String, walking: Bool, walkArray: [String], distArray: [String], shareId: String, shared: Bool) {
        self.name = name
        self.image = image
        self.firstTimer = firstTimer
        self.secondTimer = secondTimer
        self.walking = walking
        self.walkArray = walkArray
        self.distArray = distArray
        self.shareId = shareId
        self.shared = shared
   }
    
    init(snapshot: QueryDocumentSnapshot) {
        let snapshotValue = snapshot.data() as [String : Any]
        name = snapshotValue["name"] as! String
        image = snapshotValue["image"] as! String
        firstTimer = snapshotValue["firstTimer"] as! String
        secondTimer = snapshotValue["secondTimer"] as! String
        walking = snapshotValue["walking"] as! Bool
        walkArray = snapshotValue["walkArray"] as! [String]
        distArray = snapshotValue["distArray"] as! [String]
        shareId = snapshotValue["shareId"] as! String
        shared = snapshotValue["shared"] as! Bool
        id = snapshot.documentID
    }
    
    func toAny() -> [String: Any] {
        return ["name": name, "image": image, "firstTimer": firstTimer, "secondTimer": secondTimer, "walking": walking, "walkArray": walkArray, "distArray": distArray, "shareId": shareId, "shared": shared]
    }
    
//    func startTimer() {
//        if(totalTime == 0) {
//            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
//        }
//        else {
//            print("can't create new timer")
//        }
//    }
//
//    func timeFormatted(_ totalSeconds: Int) -> String {
//        let seconds: Int = totalSeconds % 60
//        let minutes: Int = (totalSeconds / 60) % 60
//        //     let hours: Int = totalSeconds / 3600
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
//
//    func stopTimer () {
//        timer.invalidate()
//    }
//
//    @objc func updateTime() {
//        dogTimer = "\(timeFormatted(totalTime))"
//        print(name + " " + dogTimer)
//        if totalTime != 1000 {
//            totalTime += 1
//        } else {
//            timer.invalidate()
//        }
//    }
}
