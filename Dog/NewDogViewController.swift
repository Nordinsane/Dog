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
    @IBOutlet weak var saveDogButton: UIButton!
    @IBOutlet weak var cancelDogButton: UIButton!
    @IBOutlet weak var dogImagePreview: UIButton!
    
    override func viewDidLoad() {
        isEditing = false
        super.viewDidLoad()
        
        saveDogButton.layer.cornerRadius = 25
        cancelDogButton.layer.cornerRadius = 25
        //dogNameEntry.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dogNameEntry.resignFirstResponder()
        return true
    }
    
    @IBAction func selectDogImage(_ sender: UIButton) {
        openGallery()
    }
    
    @IBAction func saveDog(_ sender: UIButton) {
        
        let apply = DogEntry(name: dogNameEntry.text ?? "-", image: dogImagePreview.imageView?.image ?? #imageLiteral(resourceName: "TempDog"), color: UIColor.gray, firstTimer: "", secondTimer: "", walk: false, walkArray: [""], title: "pap", isImportant: false, isFinished: false)
        
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
        
        dogImagePreview.setImage(image, for: .normal)
    }
}
