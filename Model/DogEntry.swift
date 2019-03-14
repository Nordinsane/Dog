//
//  DogEntry.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-10.
//  Copyright © 2019 kim. All rights reserved.
//

import Foundation
import UIKit

class DogEntry {
    
    var name: String
    var image: UIImage
    var color: UIColor
    var firstTimer: String
    var secondTimer: String
    var walk: Bool = false

    
    
    init(name: String, image: UIImage, color: UIColor, firstTimer: String, secondTimer: String, walk: Bool) {
        self.name = name
        self.image = image
        self.color = color
        self.firstTimer = firstTimer
        self.secondTimer = secondTimer
        self.walk = walk
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
