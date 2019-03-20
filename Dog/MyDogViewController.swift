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
    @IBOutlet weak var latestWalkDisplay: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    var thisDog: DogEntry?
    
    let calendar = Calendar.current
    let format = DateFormatter()
    
    @IBAction func walkActionButton(_ sender: UIButton) {
        format.dateFormat = "HH:mm:ss"
        let date = Date()
        let formattedDate = format.string(from: date)
        if thisDog?.walk == false {
            latestWalkDisplay.text = ""
            thisDog?.firstTimer = (formattedDate)
            latestWalkDisplay.text = thisDog?.firstTimer
            latestWalkDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
            walkButton.setTitle("Stop", for: .normal)
            thisDog?.walk = true
        }
        else if thisDog?.walk == true {
            walkButton.isEnabled = false
            thisDog?.secondTimer = (formattedDate)
            walkButton.setTitle("", for: .normal)
            let combinedTime = ((thisDog?.firstTimer ?? "none") + " | " + (thisDog?.secondTimer ?? "none"))
            latestWalkDisplay.text = combinedTime
            latestWalkDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            thisDog?.walk = false
            thisDog?.walkArray.append(combinedTime)
            historyTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            historyTableView.reloadData()
//            UIView.animate(withDuration: 1.2, delay: 0.0, options: [],
//                           animations: {
//
//            },
//                           completion: nil
//            );
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                self.walkButton.setTitle("Walk", for: .normal)
//                self.latestWalkDisplay.text = ""
//                self.walkButton.isEnabled = true
//            }
            walkButton.setTitle("Walk", for: .normal)
            self.walkButton.isEnabled = true
        }
        print(formattedDate + " formatted")
        print(thisDog?.walkArray.count)
        print(thisDog?.walkArray.last)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        latestWalkDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
        
        if thisDog?.walk == true {
            walkButton.setTitle("Stop", for: .normal)
            latestWalkDisplay.text = thisDog?.firstTimer
        }
        
        walkButton.layer.cornerRadius = 30
        walkButton.layer.masksToBounds = true
        
//        dogImage.layer.cornerRadius = 35
//        dogImage.layer.masksToBounds = true
        dogImage.image = thisDog?.image
        dogName.text = thisDog?.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thisDog?.walkArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath) as! WalkHistoryTableCell
        
        cell.timeDisplay.text = thisDog?.walkArray[indexPath.row]
        cell.timeDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-2) {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [],
                           animations: {
                            cell.timeDisplay.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            },
                           completion: nil
            );
        }
        
        if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
            cell.timeDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [],
                           animations: {
                            cell.timeDisplay.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            },
                           completion: nil
            );
        }
        return cell //4.
    }
}
