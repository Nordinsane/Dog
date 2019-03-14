//
//  NewDogViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-08.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit

class NewDogViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var dog : Dog?

    @IBOutlet weak var dogNameEntry: UITextField!
    @IBOutlet weak var dogImagePreview: UIImageView!
    @IBOutlet weak var saveDogButton: UIButton!
    @IBOutlet weak var cancelDogButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveDogButton.layer.cornerRadius = 25
        cancelDogButton.layer.cornerRadius = 25
        //dogNameEntry.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        dogNameEntry.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    
    @IBAction func selectDogImage(_ sender: UIButton) {
        openGallery()
    }
    
    @IBAction func saveDog(_ sender: UIButton) {
        let apply = DogEntry(name: dogNameEntry.text ?? "-", image: dogImagePreview.image ?? #imageLiteral(resourceName: "TempDog"), color: UIColor.gray, firstTimer: "", secondTimer: "", walk: false)
        dog?.addDog(dog: apply)
    }
    
    @IBAction func cancelDog(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "saveDogSegue", sender: nil)
    }
    
    func openGallery() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =
            UIImagePickerController.SourceType.photoLibrary
        myPickerController.allowsEditing = true
        present(myPickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        dogImagePreview.image = image
    }
}
