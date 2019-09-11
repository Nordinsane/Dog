//
//  DogTableViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-08.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FBSDKLoginKit

class DogTableViewController: UITableViewController {
    
    var db: Firestore!
    var auth: Auth!
    let myDogId = "getDogSegueId"
    let newDogId = "newDogSegueId"
    let logoutId = "logoutUserSegue"
    let dogs = Dogs()
    var users = [User]()
    var thisDog = [DogEntry]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        auth = Auth.auth()
        
        isEditing = false

        guard let user = auth.currentUser else {return}

        let dogsRef = db.collection("users").document(user.uid).collection("dogs")
        
        dogsRef.addSnapshotListener() {
            (snapshot, err) in
            self.dogs.clearDog()

            for document in snapshot!.documents {
               let dog = DogEntry(snapshot: document)
                print(dog.name)
                self.dogs.addDog(dog: dog)
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // * Allow swipeable Table-rows * //
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // * Performs the Delete Action on select, removing all related Firebase data * //
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            if let user = self.auth.currentUser {
                if let dogId = self.dogs.entry(index: indexPath.row)?.id {
                    let dogsRef = self.db.collection("users").document(user.uid).collection("dogs").document(dogId)
                    dogsRef.delete()
                    self.dogs.deleteDog(index: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    completion(true)
                    print("Dog deleted")
                }
                else {
                    print("Can't update timer")
                }
            }
            
        }
        action.backgroundColor = UIColor.red
        return action
    }
    
//    @IBAction func editRowsAction(_ sender: Any) {
//        isEditing = !isEditing
//    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 170
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DogTableCell
        
        let dogimage = dogs.entry(index: indexPath.row)?.image
        
        if let image = dogimage {
            guard let url = URL(string: image) else {print("bad url"); return UITableViewCell()}
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    cell.dogCellDisplay.image = UIImage(data: data!)
                }
            }).resume()
        }
        
        cell.dogCellName.text = dogs.entry(index: indexPath.row)?.name
        
        // * Each dog (cell) display their timer/timers depending on if the dog is walking/has walked * //
        if dogs.entry(index: indexPath.row)?.walking == true {
            cell.dogStatusDisplay.text = "Walking"
            cell.dogTimerDisplay.text = dogs.entry(index: indexPath.row)?.firstTimer ?? ""
            cell.dogTimerDisplay.textColor = UIColor(red:1.00, green:0.45, blue:0.00, alpha:1.0)
        }
        else if dogs.entry(index: indexPath.row)?.walking == false {
            cell.dogTimerDisplay.text = dogs.entry(index: indexPath.row)?.walkArray[0] ?? ""
            cell.dogStatusDisplay.text = "Latest Walk"
            cell.dogTimerDisplay.textColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
        }
        
        cell.dogCellDisplay.layer.masksToBounds = false
        cell.dogCellDisplay.layer.shadowColor = UIColor.black.cgColor
        cell.dogCellDisplay.layer.shadowOpacity = 0.5
        cell.dogCellDisplay.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.dogCellDisplay.layer.shadowRadius = 1
        
        cell.dogCellDisplay.layer.shadowPath = UIBezierPath(rect: cell.dogCellDisplay.bounds).cgPath
        cell.dogCellDisplay.layer.shouldRasterize = true
        cell.dogCellDisplay.layer.rasterizationScale = 1
        
        cell.dogCellDisplay.layer.cornerRadius = cell.dogCellDisplay.frame.height/2
        cell.dogCellDisplay.layer.shadowPath = UIBezierPath(rect: cell.dogCellDisplay.bounds).cgPath
        cell.dogCellDisplay.layer.masksToBounds = true
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == myDogId {
            guard let destination = segue.destination as? MyDogViewController else {return}
            guard let cell = sender as? UITableViewCell else {return}
            guard let indexPath = tableView.indexPath(for: cell) else {return}
            guard let entry = dogs.entry(index: indexPath.row) else {return}
            
            destination.thisDog = entry
            
        }
        else if segue.identifier == newDogId {
            if let destination = segue.destination as? NewDogViewController   {
                destination.dogs = dogs
            }
        }
    }
    @IBAction func logoutButtonAction(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        }catch{
            print("Error")
        }
        do {
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }catch{
            print("Error")
        }
    guard(navigationController?.popToRootViewController(animated: true)) != nil
            else {return}
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        if sender.source is NewDogViewController {
            tableView.reloadData()
        }
    }
}
