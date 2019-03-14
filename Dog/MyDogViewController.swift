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
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var firstTimeDisplay: UILabel!
    @IBOutlet weak var secondTimeDisplay: UILabel!
    @IBOutlet weak var firstWalkHistoryDisplay: UILabel!
    @IBOutlet weak var secondWalkHistoryDisplay: UILabel!
    
    var thisDog: DogEntry?
    
    let calendar = Calendar.current
    
    @IBAction func walkActionButton(_ sender: UIButton) {
        let date = Date()
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        if thisDog?.walk == false {
            firstTimeDisplay.text = ""
            secondTimeDisplay.text = ""
            thisDog?.firstTimer = (String(hour) + " : " + String(minute))
            firstTimeDisplay.text = thisDog?.firstTimer
            walkButton.setTitle("Stop", for: .normal)
            thisDog?.walk = true
        }
        else if thisDog?.walk == true {
            thisDog?.secondTimer = (String(hour) + " : " + String(minute))
            walkButton.setTitle("Take a Walk", for: .normal)
            secondTimeDisplay.text = thisDog?.secondTimer
            firstWalkHistoryDisplay.text = thisDog?.firstTimer
            secondWalkHistoryDisplay.text = thisDog?.secondTimer
            thisDog?.walk = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if thisDog?.walk == true {
            walkButton.setTitle("Stop", for: .normal)
            firstTimeDisplay.text = thisDog?.firstTimer
        }
        
        firstWalkHistoryDisplay.text = thisDog?.firstTimer
        secondWalkHistoryDisplay.text = thisDog?.secondTimer
//        dogImage.layer.cornerRadius = 35
//        dogImage.layer.masksToBounds = true
        dogImage.image = thisDog?.image
        dogName.text = thisDog?.name
    }
}
