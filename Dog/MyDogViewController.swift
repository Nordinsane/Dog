//
//  MyDogViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-08.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit
import Firebase
import CoreMotion
import SDWebImage

class MyDogViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var latestWalkDisplay: UILabel!
    @IBOutlet weak var blurDisplay: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dogNameEdit: UITextField!
    
    var db: Firestore!
    var auth: Auth!
    var storage: Storage!
    var thisDog: DogEntry?
    var walkData: String = ""
    var edit = false
    
    let dogs = Dogs()
    let calendar = Calendar.current
    let format = DateFormatter()
    let cellId = "historyTableCell"
    let segueId = "walkHistorySegue"
    var timeArray = [String]()
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    // * Checks if the dog is walking or not, since the timer button should conform to that with "Start"-ing or "Stop"-ing * //
    // * At the end of an action the Database values are updated * //
    
    func random(length: Int = 10) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        print(randomString)
        return randomString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        dogNameEdit.isHidden = true;
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

//        // * Get the image by URL and set it as the background * //
        if let image = dogimage {
            guard let url = URL(string: image) else {print("bad url"); return}
            dogImage.sd_setImage(with: url, completed: .none)
//            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//
//                if error != nil {
//                    print(error!)
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    self.dogImage.image = UIImage(data: data!)
//                }
//            }).resume()
        }
    }
    
    private func updateActivity() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        }
    }
    
    @IBAction func walkActionButton(_ sender: UIButton) {
        format.dateFormat = "HH:mm"
        let date = Date()
        let formattedDate = format.string(from: date)
        
        guard let user = auth.currentUser else {return}
        
        if thisDog?.walking == false {
            pedometer.queryPedometerData(from: calendar.startOfDay(for: Date()), to: Date()) { (data, error) in
                print(data)
            }

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
            stopActivity()
            walkButton.isEnabled = false
            thisDog?.secondTimer = (formattedDate)
            let alert = UIAlertController(title: "Save walk?", message: "Do you want to remember this walk?" + (thisDog!.firstTimer) + " | " + (thisDog!.secondTimer), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
                let combinedTime = ((self.thisDog?.firstTimer ?? "none") + " | " + (self.thisDog?.secondTimer ?? "none"))
                self.latestWalkDisplay.text = combinedTime
                self.thisDog?.distArray.insert(self.walkData, at: 0)
                self.latestWalkDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
                self.thisDog?.walkArray.insert(combinedTime, at: 0)
                self.tableView.reloadData()
                
                
                // * Puts new timers at the top of the Table * //
                self.timeArray = self.thisDog?.walkArray ?? [""]
                let topIndex = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: topIndex, at: .top, animated: true)
                if let dogId = self.thisDog?.id {
                    let dogsRef = self.db.collection("users").document(user.uid).collection("dogs").document(dogId)
                    
                    dogsRef.updateData([
                        "secondTimer": self.thisDog?.secondTimer,
                        "walkArray": self.timeArray,
                        "walking": false,
                        "distArray": self.thisDog?.distArray
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
                self.thisDog?.firstTimer = (formattedDate)
            }))
            alert.addAction(UIAlertAction(title: "Don't save", style: .cancel, handler: { action in
                self.latestWalkDisplay.text = nil
            }))
            self.present(alert, animated: true)
            
            self.thisDog?.walking = false
            walkButton.setTitle("", for: .normal)
            self.walkButton.isEnabled = true
            walkButton.setTitle(NSLocalizedString("Walk", comment: "Walk"), for: .normal)
            // * Stylize the text before being displayed * //
            
            
        }
    }
    
    private func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.walking {
                    print("Walking")
                } else if activity.stationary {
                    print("Stationary")
                } else if activity.running {
                    print("Running")
                } else if activity.automotive {
                    print("Automotive")
                }
            }
        }
    }
    
    func startCountingSteps() -> String {
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                print(pedometerData.numberOfSteps.stringValue)
                let returnedData = pedometerData.numberOfSteps.stringValue
                self?.walkData = returnedData
            }
        }
        return walkData
    }
    
    func stopActivity() {
        pedometer.stopUpdates()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func editDog(_ sender: UIButton) {
        guard let user = auth.currentUser else {return}
        
        edit = !edit

        if edit {
            dogName.isHidden = true
            dogNameEdit.isHidden = false
            editButton.setTitle("Save", for: .normal)
        }
        else if !edit {
            dogName.isHidden = false
            dogNameEdit.isHidden = true
            editButton.setTitle("Edit", for: .normal)
            let dogsRef = db.collection("users").document(user.uid).collection("dogs").document(thisDog?.id ?? "")

            if let name = self.dogNameEdit.text {
                dogName.text = name
                dogsRef.updateData(["name" : name])
            }
        }
    }
    
    // * CURRENTLY NOT IN USE * //
    @IBAction func shareDog(_ sender: UIButton) {
        if thisDog?.shareId == "" && thisDog?.shared == false {
            guard let user = auth.currentUser else {return}
            let publicRef = db.collection("public-dogs")
            let uuid = UUID().uuidString

            if let dogId = thisDog?.id {
                thisDog?.shared = true
                let dogsRef = db.collection("users").document(user.uid).collection("dogs").document(dogId)
                dogsRef.updateData(["shareId" : uuid])
                let dog = DogEntry(name: thisDog?.name ?? "", image: thisDog?.image ?? "", firstTimer: thisDog?.firstTimer ?? "", secondTimer: thisDog?.secondTimer ?? "", walking: thisDog?.walking ?? false, walkArray: thisDog?.walkArray ?? [""], distArray: thisDog?.distArray ?? [""], shareId: uuid, shared: true)

                publicRef.addDocument(data: dog.toAny())
                guard let name = thisDog?.name else {
                    return
                }
                
                let alert = UIAlertController(title: "\(name) shared!", message: "Access Code: \(uuid)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Copy ID", style: .default, handler: { action in
                    self.copyToClipboard(text: uuid)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
        else {
            guard let name = thisDog?.name else {
                return
            }
            guard let id = thisDog?.shareId else {
                return
            }
            let alert = UIAlertController(title: "\(name) shared!", message: "Access Code: \(id)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Copy ID", style: .default, handler: { action in
                self.copyToClipboard(text: id)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func copyToClipboard(text: String) {
        UIPasteboard.general.string = text
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
        
        cell.distanceDisplay.text = thisDog?.distArray[indexPath.row]
        cell.timeDisplay.text = thisDog?.walkArray[indexPath.row]
        cell.distanceDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        cell.timeDisplay.textColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        return cell
    }
}
