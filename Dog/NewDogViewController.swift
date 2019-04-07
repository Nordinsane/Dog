//
//  NewDogViewController.swift
//  Dog
//
//  Created by Kim Nordin on 2019-03-08.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit
import Firebase

class NewDogViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var db: Firestore!
    var auth: Auth!
    var storage: Storage!
    var canCreateDog = false
    var dogs : Dogs?

    @IBOutlet weak var dogNameEntry: UITextField!
    @IBOutlet weak var saveDogButton: UIButton!
    @IBOutlet weak var cancelDogButton: UIButton!
    @IBOutlet weak var dogImagePreview: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storage = Storage.storage()
        db = Firestore.firestore()
        auth = Auth.auth()
        
        isEditing = false
        canCreateDog = true
        saveDogButton.layer.cornerRadius = 25
        cancelDogButton.layer.cornerRadius = 25
        dogNameEntry.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dogNameEntry.resignFirstResponder()
        return true
    }
    
    @IBAction func selectDogImage(_ sender: UIButton) {
        openGallery()
    }
    
    @IBAction func saveDog(_ sender: UIButton) {
        if(canCreateDog == true) {
            guard let user = auth.currentUser else {return}
            
            let storageRef = storage.reference()
            let dogsRef = db.collection("users").document(user.uid).collection("dogs")
            
            guard let imageData = dogImagePreview.imageView?.image!.jpegData(compressionQuality: 0.5) else {return}
            let uuid = UUID().uuidString
            let imageRef = storageRef.child("images/\(user.uid)/\(uuid).jpg")
            let uploadTask = imageRef.putData(imageData, metadata: nil) {
             (metadata, error) in
                print("uploaded")
                
                
                imageRef.downloadURL {
                    (url, error) in
                    
                    guard let downloadUrl = url else {return}
                    if let name = self.dogNameEntry.text {
                        
                        let dog = DogEntry(name: name, image: downloadUrl.absoluteString, firstTimer: "", secondTimer: "", walking: false, walkArray: [""])
                        dogsRef.addDocument(data: dog.toAny())
                    }
                }
            }
        
            
            
        }
        canCreateDog = false
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
