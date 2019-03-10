//
//  MyDogViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-08.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit

class MyDogViewController: UIViewController {

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    
    var thisDog: DogEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogImage.image = thisDog?.image
        dogName.text = thisDog?.name
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
