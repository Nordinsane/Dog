//
//  DogTableViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-08.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit

class DogTableViewController: UITableViewController {
    
    let myDogId = "getDogSegueId"
    let newDogId = "newDogSegueId"
    let dog = Dog()
    var index = 0
    let dogNameArray = ["Kalle", "Tjalle", "Bilbo", "Pluto", "Roffsan", "Balto", "Fido"]
    let dogImageArray = [#imageLiteral(resourceName: "Husky"), #imageLiteral(resourceName: "Bull"), #imageLiteral(resourceName: "Corgi"), #imageLiteral(resourceName: "Pitboard"), #imageLiteral(resourceName: "Shiba"), #imageLiteral(resourceName: "CutePup"), #imageLiteral(resourceName: "Pom")]
    let dogColorArray = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple, UIColor.yellow, UIColor.magenta]
    let dogTimerArray = ["", "", "", "", "", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<2 {
            let apply = DogEntry(name: dogNameArray[index], image: dogImageArray[index], color: dogColorArray[index], dogTimer: dogTimerArray[index])
            dog.addDog(dog: apply)
        }
        print(dog)
        print(dog.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
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
//        cell.cellBackgroundView.backgroundColor = dog.entry(index: indexPath.row)?.color
        
//        cell.dogCellDisplay.layer.cornerRadius = 20
//        cell.dogCellDisplay.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
//        cell.dogCellDisplay.layer.cornerRadius = 20
//        cell.dogCellDisplay.layer.masksToBounds = true

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
        if segue.identifier == newDogId {
            if let destination = segue.destination as? NewDogViewController   {
                destination.dog = dog
            }
        }
    }
}
