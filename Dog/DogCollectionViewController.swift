//
//  DogCollectionViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-09.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DogCollectionViewController: UICollectionViewController {

    let myDogId = "getDogSegueId"
    let newDogId = "newDogSegueId"
    let dog = Dog()
    let dogNameArray = ["Kalle", "Tjalle", "Bilbo", "Pluto", "Roffsan", "Balto", "Fido"]
    let dogImageArray = [#imageLiteral(resourceName: "Husky"), #imageLiteral(resourceName: "Bull"), #imageLiteral(resourceName: "Corgi"), #imageLiteral(resourceName: "Pitboard"), #imageLiteral(resourceName: "Shiba"), #imageLiteral(resourceName: "CutePup"), #imageLiteral(resourceName: "Pom")]
    let dogColorArray = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple, UIColor.yellow, UIColor.magenta]
    let dogTimerArray = [Timer(), Timer(), Timer(), Timer(), Timer(), Timer(), Timer()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for index in 0..<6 {
//            let apply = DogEntry(name: dogNameArray[index], image: dogImageArray[index], color: dogColorArray[index], timer: dogTimerArray[index])
//            dog.addDog(dog: apply)
//        }
        print(dog)
        print(dog.count)
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
//        cellBackgroundView.layer.cornerRadius = cellBackgroundView.frame.height/2

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dog.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DogCollectionCell
        
        cell.dogCellName.text = dog.entry(index: indexPath.row)?.name
        cell.dogCellDisplay.image = dog.entry(index: indexPath.row)?.image
        cell.cellBackgroundView.backgroundColor = dog.entry(index: indexPath.row)?.color
        
        cell.cellBackgroundView.layer.cornerRadius = 35
        cell.dogCellDisplay.layer.cornerRadius = 35
        cell.dogCellDisplay.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        cell.dogCellDisplay.layer.masksToBounds = true
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == myDogId {
            
            guard let destination = segue.destination as? MyDogViewController else {return}
            guard let cell = sender as? UICollectionViewCell else {return}
            guard let indexPath = collectionView.indexPath(for: cell) else {return}
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
