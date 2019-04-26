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
    
    let dogs = Dogs()
    let calendar = Calendar.current
    let format = DateFormatter()
    let cellId = "historyTableCell"
    let segueId = "walkHistorySegue"
    var timeArray = [String]()
    
    // * Checks if the dog is walking or not, since the timer button should conform to that with "Start"-ing or "Stop"-ing * //
    // * At the end of an action the Database values are updated * //
    
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
        
        // * Style the button depending on the Status of the Dog * //
        if thisDog?.walking == true {
            latestWalkDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
            walkButton.setTitle("Stop", for: .normal)
            latestWalkDisplay.text = thisDog?.firstTimer
        }
        else if thisDog?.walking == false {
            latestWalkDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            latestWalkDisplay.text = thisDog?.walkArray.last
        }
        
        walkButton.layer.cornerRadius = 25
        walkButton.layer.masksToBounds = true
        
        let dogimage = thisDog?.image
        dogName.text = thisDog?.name
        
        dogImage.layer.cornerRadius = 35
        dogImage.layer.masksToBounds = true
        
        // * Get the image by URL and set it as the background * //
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
    
    @IBAction func walkActionButton(_ sender: UIButton) {
        format.dateFormat = "HH:mm"
        let date = Date()
        let formattedDate = format.string(from: date)
        
        guard let user = auth.currentUser else {return}
        
        if thisDog?.walking == false {
            thisDog?.firstTimer = (formattedDate)
            latestWalkDisplay.text = thisDog?.firstTimer
            latestWalkDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
            walkButton.setTitle(NSLocalizedString("Stop", comment: "Stop"), for: .normal)
            thisDog?.walking = true
            
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
            // * Stylize the text before being displayed * //
            let combinedTime = ((thisDog?.firstTimer ?? "none") + " | " + (thisDog?.secondTimer ?? "none"))
            latestWalkDisplay.text = combinedTime
            latestWalkDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            thisDog?.walking = false
            thisDog?.walkArray.insert(combinedTime, at: 0)
            tableView.reloadData()
            timeArray = thisDog?.walkArray ?? [""]
            walkButton.setTitle(NSLocalizedString("Walk", comment: "Walk"), for: .normal)
            self.walkButton.isEnabled = true
            // * Puts new timers at the top of the Table * //
            let topIndex = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: topIndex, at: .top, animated: true)
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
            thisDog?.firstTimer = (formattedDate)
        }
    }
    // * CURRENTLY NOT IN USE * //
    @IBAction func shareDog(_ sender: UIButton) {
//        if thisDog?.shareId == "" {
//            guard let user = auth.currentUser else {return}
//            let publicRef = db.collection("public-dogs")
//            let uuid = UUID().uuidString
//
//            if let dogId = thisDog?.id {
//
//                let dogsRef = db.collection("users").document(user.uid).collection("dogs").document(dogId)
//                dogsRef.updateData(["shareId" : uuid])
//                let dog = DogEntry(name: thisDog?.name ?? "", image: thisDog?.image ?? "", firstTimer: thisDog?.firstTimer ?? "", secondTimer: thisDog?.secondTimer ?? "", walking: thisDog?.walking ?? false, walkArray: thisDog?.walkArray ?? [""], shareId: uuid)
//
//                publicRef.addDocument(data: dog.toAny())
//            }
//        }
    }
    
    // * Apply blur to specific view * //
    func blur() {
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = blurDisplay.bounds
        blurDisplay.addSubview(blurView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thisDog?.walkArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableCell", for: indexPath) as! WalkHistoryTableCell

        cell.timeDisplay.text = thisDog?.walkArray[indexPath.row]
        cell.timeDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        return cell
    }
}
