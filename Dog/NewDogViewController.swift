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

    override func viewDidLoad() {
        super.viewDidLoad()
        dogNameEntry.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectDogImage(_ sender: UIButton) {
        openGallery()
    }
    
    @IBAction func saveDog(_ sender: UIButton) {
        let apply = DogEntry(name: dogNameEntry.text ?? "-", image: dogImagePreview.image ?? #imageLiteral(resourceName: "TempDog"))
        dog?.addDog(dog: apply)
        print(dog?.count)
    }
    
    @IBAction func cancelDog(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
