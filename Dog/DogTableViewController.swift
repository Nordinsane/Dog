//
//  DogTableViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-08.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit
import Firebase

class DogTableViewController: UITableViewController {
    
    let myDogId = "getDogSegueId"
    let newDogId = "newDogSegueId"
    let logoutId = "logoutUserSegue"
    let dog = Dog()
    var index = 0
    let dogNameArray = ["Kalle", "Tjalle", "Bilbo", "Pluto", "Roffsan", "Balto", "Fido"]
    let dogImageArray = [#imageLiteral(resourceName: "Husky"), #imageLiteral(resourceName: "Pitboard"), #imageLiteral(resourceName: "Corgi"), #imageLiteral(resourceName: "Pom"), #imageLiteral(resourceName: "Shiba"), #imageLiteral(resourceName: "CutePup"), #imageLiteral(resourceName: "Pom")]
    let dogColorArray = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple, UIColor.yellow, UIColor.magenta]
    let dogTimerArray = ["", "", "", "", "", "", ""]
    var items =  [Item]()
    var users =  [User]()
    var thisDog = [DogEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEditing = false

//        let dbase = Firestore.firestore()
//
//        let food = Item(name: "spatula")
//        dbase.collection("items").addDocument(data: food.toAny())
//        let dood = Item(name: "a pile of bread")
//        dbase.collection("items").addDocument(data: dood.toAny())
//
//        let email = User(cred: "Email")
//        dbase.collection("users").addDocument(data: email.toAny())
//        let dbase = Database.database().reference(withPath: "dogs")
//        
//        let rootRef = Database.database().reference()
//        
//        let childRef = Database.database().reference(withPath: "grocery-items")
//        
//        // 3
//        let itemsRef = rootRef.child("grocery-items")
//        
//        // 4
//        let milkRef = itemsRef.child("milk")
        
        // 5
//        print(rootRef.key)   // prints: ""
//        print(childRef.key)  // prints: "grocery-items"
//        print(itemsRef.key)  // prints: "grocery-items"
//        print(milkRef.key)   // prints: "milk"
//
        
        for index in 0..<4 {
            let apply = DogEntry(name: dogNameArray[index], image: dogImageArray[index], color: dogColorArray[index], firstTimer: "", secondTimer: "", walk: false, walkArray: [""], title: "va", isImportant: false, isFinished: false)
            dog.addDog(dog: apply)
        }
        print(dog)
        print(dog.count)
        
//        let dbase = Firestore.firestore()
//
//        let food = Item(name: "Food")
//        dbase.collection("items").addDocument(data: food.toAny())
//
//        let email = User(cred: "Email")
//        dbase.collection("users").addDocument(data: email.toAny())
//        let itemsRef = dbase.collection("users")
//
//        let ost = ["name" : "ost", "done" : false] as [String : Any]
//
//        dbase.collection("items").document("ost").setData(ost)
//
//        dbase.collection("items").addDocument(data: ost)
//
//        itemsRef.addSnapshotListener() {
//            (snapshot, err) in
//            var newItems = [Item]()
//            for document in snapshot!.documents {
//
//                let item = Item(snapshot: document)
//                newItems.append(item)
//                print(item.name)
//            }
//            print(newItems.count)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            
            self.dog.deleteDog(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = UIColor.red
        return action
    }
    
    @IBAction func editRowsAction(_ sender: Any) {
        isEditing = !isEditing
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = dog.list[sourceIndexPath.row]
        dog.deleteDog(index: sourceIndexPath.row)
        dog.list.insert(itemToMove, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 170
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dog.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DogTableCell
        
        cell.dogCellName.text = dog.entry(index: indexPath.row)?.name
        cell.dogCellDisplay.image = dog.entry(index: indexPath.row)?.image
        cell.dogTimerDisplay.text = dog.entry(index: indexPath.row)?.walkArray.last
//        cell.cellBackgroundView.backgroundColor = dog.entry(index: indexPath.row)?.color
        

        cell.dogCellDisplay.layer.cornerRadius = cell.dogCellDisplay.frame.height/2
        cell.dogCellDisplay.layer.shadowPath = UIBezierPath(rect: cell.dogCellDisplay.bounds).cgPath

//        cell.dogCellDisplay.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
//        cell.dogCellDisplay.layer.cornerRadius = 20
        cell.dogCellDisplay.layer.masksToBounds = true

        print(cell.dogCellName.text)
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == myDogId {
            
            guard let destination = segue.destination as? MyDogViewController else {return}
            guard let cell = sender as? UITableViewCell else {return}
            guard let indexPath = tableView.indexPath(for: cell) else {return}
            guard let entry = dog.entry(index: indexPath.row) else {return}
            
            destination.thisDog = entry
            
        }
        else if segue.identifier == newDogId {
            if let destination = segue.destination as? NewDogViewController   {
                destination.dog = dog
            }
        }
    }
    @IBAction func logoutButtonAction(_ sender: UIBarButtonItem) {
        print(Auth.auth().currentUser?.email)
        
        do {
            try Auth.auth().signOut()
        }catch{
            print("Error")
        }
        
        guard(navigationController?.popToRootViewController(animated: true)) != nil
            else {return}
        
        print(Auth.auth().currentUser?.email)
    }
}
