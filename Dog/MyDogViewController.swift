//
//  MyDogViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-08.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit

class MyDogViewController: UIViewController {

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var dogTimer: UILabel!
    @IBOutlet weak var walkButton: UIButton!
    
    var countdownTimer = Timer()
    var thisDog: DogEntry?
    var timerOn = false
    
    @IBAction func walkActionButton(_ sender: UIButton) {
        if thisDog?.totalTime == 100 {
            thisDog?.startTimer()
            walkButton.setTitle("Stop", for: .normal)
        }
        else {
            walkButton.setTitle("Take a Walk", for: .normal)
            thisDog?.stopTimer()
            thisDog?.totalTime = 100
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dogImage.layer.cornerRadius = 35
//        dogImage.layer.masksToBounds = true
        tick()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        dogImage.image = thisDog?.image
        dogName.text = thisDog?.name
    }
    @objc func tick() {
        dogTimer.text = thisDog?.dogTimer
    }
}
