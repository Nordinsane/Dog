//
//  MyDogViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-08.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit

class MyDogViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var firstTimeDisplay: UILabel!
    @IBOutlet weak var secondTimeDisplay: UILabel!
    @IBOutlet weak var firstWalkHistoryDisplay: UILabel!
    @IBOutlet weak var secondWalkHistoryDisplay: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
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
            walkButton.isEnabled = false
            thisDog?.secondTimer = (String(hour) + " : " + String(minute))
            walkButton.setTitle("Take a Walk", for: .normal)
            secondTimeDisplay.text = thisDog?.secondTimer
            firstWalkHistoryDisplay.text = thisDog?.firstTimer
            secondWalkHistoryDisplay.text = thisDog?.secondTimer
            let combinedTime = ((thisDog?.firstTimer ?? "none") + " | " + (thisDog?.secondTimer ?? "none"))
            thisDog?.walk = false
            thisDog?.walkArray.append(combinedTime)
            historyTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.firstTimeDisplay.text = ""
                self.secondTimeDisplay.text = ""
                self.walkButton.isEnabled = true
            }
        }
        print(thisDog?.walkArray.count)
        print(thisDog?.walkArray.last)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thisDog?.walkArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath) as! WalkHistoryTableCell
        
        cell.timeDisplay.text = thisDog?.walkArray[indexPath.row]
        
        return cell //4.
    }
}
