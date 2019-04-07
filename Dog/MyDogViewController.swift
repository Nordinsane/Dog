//
//  MyDogViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-08.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit
import Firebase

class MyDogViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var latestWalkDisplay: UILabel!
    @IBOutlet weak var blurDisplay: UILabel!
    
    var db: Firestore!
    var auth: Auth!
    var storage: Storage!
    var thisDog: DogEntry?
    var dogRef: DocumentReference!
    
    let calendar = Calendar.current
    let format = DateFormatter()
    let cellId = "historyTableCell"
    var timeArray = [String]()
    
    @IBAction func walkActionButton(_ sender: UIButton) {
        format.dateFormat = "HH:mm:ss"
        let date = Date()
        let formattedDate = format.string(from: date)
        
        guard let user = auth.currentUser else {return}
        
        if thisDog?.walking == false {
            thisDog?.firstTimer = (formattedDate)
            latestWalkDisplay.text = thisDog?.firstTimer
            latestWalkDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
            walkButton.setTitle("Stop", for: .normal)
            thisDog?.walking = true
//            thisDog?.walkArray.append("bananers")
            
            if let dogId = thisDog?.id {
                let dogsRef = db.collection("users").document(user.uid).collection("dogs").document(dogId)
                
                dogsRef.updateData([
                    "firstTimer": thisDog?.firstTimer,
                    "walking": true
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
            else {
                print("Can't update timer")
            }
        }
        else if thisDog?.walking == true {
            walkButton.isEnabled = false
            thisDog?.secondTimer = (formattedDate)
            walkButton.setTitle("", for: .normal)
            let combinedTime = ((thisDog?.firstTimer ?? "none") + " | " + (thisDog?.secondTimer ?? "none"))
            latestWalkDisplay.text = combinedTime
            latestWalkDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            thisDog?.walking = false
            
            thisDog?.walkArray.append(combinedTime)
            tableView.reloadData()
            timeArray = thisDog?.walkArray ?? [""]
            walkButton.setTitle("Walk", for: .normal)
            self.walkButton.isEnabled = true
            print(formattedDate + " formatted")
            if let dogId = thisDog?.id {
                let dogsRef = db.collection("users").document(user.uid).collection("dogs").document(dogId)
                
                dogsRef.updateData([
                    "secondTimer": thisDog?.secondTimer,
                    "walkArray": timeArray,
                    "walking": false
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
            else {
                print("Can't update timer")
            }
            
        }
        print(thisDog?.walkArray.count)
        print(thisDog?.walkArray.last)
        print(thisDog?.walkArray)
        print(thisDog?.firstTimer)
        print(thisDog?.secondTimer)
        print(thisDog?.name)
        print(thisDog?.firstTimer)
        print(thisDog?.firstTimer)
        
        print("time Array: ", timeArray)
        
        thisDog?.firstTimer = (formattedDate)
    }
    
    func blur() {
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = blurDisplay.bounds
        
        blurDisplay.addSubview(blurView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return timeArray.count
        return thisDog?.walkArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableCell", for: indexPath) as! WalkHistoryTableCell
//        cell.timeDisplay.text = timeArray[indexPath.row]
        cell.timeDisplay.text = thisDog?.walkArray[indexPath.row]
        cell.timeDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
//        if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-2) {
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: [],
//                           animations: {
//                            cell.timeDisplay.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//            },
//                           completion: nil
//            );
//        }
//
//        if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
//            cell.timeDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: [],
//                           animations: {
//                            cell.timeDisplay.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//            },
//                           completion: nil
//            );
//        }
        return cell //4.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        blurDisplay.layer.cornerRadius = 25
//        blurDisplay.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.layer.cornerRadius = 25
        tableView.clipsToBounds = true
        blurDisplay.clipsToBounds = true
        blur()
        
        db = Firestore.firestore()
        auth = Auth.auth()



        if thisDog?.walking == true {
            latestWalkDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
            walkButton.setTitle("Stop", for: .normal)
            latestWalkDisplay.text = thisDog?.firstTimer
        }
        else if thisDog?.walking == false {
            latestWalkDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            latestWalkDisplay.text = thisDog?.walkArray.last
        }

        walkButton.layer.cornerRadius = 30
        walkButton.layer.masksToBounds = true

        print("Hundbild \(thisDog?.image)")

        let dogimage = thisDog?.image
        dogName.text = thisDog?.name
        
        dogImage.layer.cornerRadius = 35
        dogImage.layer.masksToBounds = true

        if let image = dogimage {
            guard let url = URL(string: image) else {print("bad url"); return}
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                if error != nil {
                    print(error!)
                    return
                }

                DispatchQueue.main.async {
                    self.dogImage.image = UIImage(data: data!)
                }
            }).resume()
        }
    }
}
