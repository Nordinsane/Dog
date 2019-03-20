//
//  DogCollectionViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-18.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit

class DogCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let dogNameArray = ["Kalle", "Tjalle", "Bilbo", "Pluto", "Roffsan", "Balto", "Fido"]
    let dogImageArray = [#imageLiteral(resourceName: "CutePup"), #imageLiteral(resourceName: "Pitboard"), #imageLiteral(resourceName: "Corgi"), #imageLiteral(resourceName: "Pom"), #imageLiteral(resourceName: "Shiba"), #imageLiteral(resourceName: "CutePup"), #imageLiteral(resourceName: "Pom")]
    let dogColorArray = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple, UIColor.yellow, UIColor.magenta]
    let dogTimerArray = ["", "", "", "", "", "", ""]
    var index = 0
    
    let dog = Dog()
    var thisDog = [DogEntry]()
    
    @IBOutlet weak var dogCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        dogCollectionView.reloadData()
        super.viewDidLoad()
        dogCollectionView.delegate = self
        dogCollectionView.dataSource = self
        
        for index in 0..<4 {
            let apply = DogEntry(name: dogNameArray[index], image: dogImageArray[index], color: dogColorArray[index], firstTimer: "", secondTimer: "", walk: false, walkArray: [""], title: "va", isImportant: false, isFinished: false)
            dog.addDog(dog: apply)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dog.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dogcell", for: indexPath) as! DogCollectionCell
        cell.dogCellDisplay.image = dog.entry(index: indexPath.row)?.image
        
        cell.layer.cornerRadius = 35
        cell.layer.masksToBounds = true
        
        return cell
    }
}
