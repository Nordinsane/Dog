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
    var imageSet = false
    var dogs: Dogs?
    var thisDog: DogEntry?

    @IBOutlet weak var dogNameEntry: UITextField!
    @IBOutlet weak var saveDogButton: UIButton!
    @IBOutlet weak var cancelDogButton: UIButton!
    @IBOutlet weak var dogImagePreview: UIButton!
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dogImagePreview.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.0)
        dogNameEntry.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 0.45)])
        blur()
        
        storage = Storage.storage()
        db = Firestore.firestore()
        auth = Auth.auth()
        
        dogNameEntry.text = nil
        isEditing = false
        saveDogButton.layer.cornerRadius = 30
        cancelDogButton.layer.cornerRadius = 30
        dogNameEntry.becomeFirstResponder()
    }
    
    func blur() {
        let darkBlur = UIBlurEffect(style: UIBlurEffect.Style.regular)
        
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = backView.bounds
        
        backView.addSubview(blurView)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dogNameEntry.resignFirstResponder()
        return true
    }
    
    @IBAction func selectDogImage(_ sender: UIButton) {
        openGallery()
    }
    
    @IBAction func saveDog(_ sender: UIButton) {
        if(canCreateDog() == true) {
            guard let user = auth.currentUser else {return}
            
            let storageRef = storage.reference()
            let dogsRef = db.collection("users").document(user.uid).collection("dogs")
            
            guard let imageData = dogImagePreview.imageView?.image!.jpegData(compressionQuality: 0.5) else {return}
            let uuid = UUID().uuidString
            let imageRef = storageRef.child("images/\(user.uid)/\(uuid).jpg")
            DispatchQueue.main.async {
                
                let uploadTask = imageRef.putData(imageData, metadata: nil) {
                 (metadata, error) in
                    print("uploaded")
                    
                    
                    imageRef.downloadURL {
                        (url, error) in
                        
                        guard let downloadUrl = url else {return}
                        if let name = self.dogNameEntry.text {
                            
                            let dog = DogEntry(name: name, image: downloadUrl.absoluteString, firstTimer: "", secondTimer: "", walking: false, walkArray: [""], distArray: [""], shareId: "", shared: false)
                            dogsRef.addDocument(data: dog.toAny())
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func cancelDog(_ sender: UIButton) {
        print("sup")
    }
    
    // * CURRENTLY NOT IN USE* //
    @IBAction func addExistingDog(_ sender: UIButton) {
        if let dogName = dogNameEntry.text {
            guard let user = auth.currentUser else {return}

            let storageRef = storage.reference()
            let publicRef = db.collection("public-dogs").whereField("shareId", isEqualTo: dogName)
            let dogsRef = db.collection("users").document(user.uid).collection("dogs")

        

            publicRef.getDocuments { (snapshot, error) in
                if error != nil {
                    print(error)
                }
                else {
                    print(dogName)
                    for document in (snapshot?.documents)! {
                        if let name = document.data()["name"] as? String {
                            if let image = document.data()["image"] as? String {
                                if let firstTimer = document.data()["firstTimer"] as? String {
                                    if let secondTimer = document.data()["secondTimer"] as? String {
                                        if let walking = document.data()["walking"] as? Bool {
                                            if let walkArray = document.data()["walkArray"] as? [String] {
                                                    if let distArray = document.data()["distArray"] as? [String] {
                                                        if let shareId = document.data()["shareId"] as? String {
                                                        let dog = DogEntry(name: name, image: image, firstTimer: firstTimer, secondTimer: secondTimer, walking: walking, walkArray: walkArray, distArray: distArray, shareId: shareId, shared: true)

                                                        dogsRef.addDocument(data: dog.toAny())
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // * Decides wether a Dog can be created or not * //
    func canCreateDog() -> Bool {
        if dogNameEntry.text == "" || imageSet == false {
            return false
        }
        else { return true }
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
        imageSet = true
        dogImagePreview.setImage(image, for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
