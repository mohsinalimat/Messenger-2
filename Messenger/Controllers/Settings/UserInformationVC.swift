//
//  UserInformationVC.swift
//  Messenger
//
//  Created by Vitaliy Paliy on 11/11/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import UIKit
import Firebase

class UserInformationVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var profileImage: ImageVC!
    @IBOutlet weak var changeImageView: BackgroundView!
    @IBOutlet weak var changeEmail: ButtonVC!
    @IBOutlet weak var changePasswordButton: ButtonVC!
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.loadImageCacheWithUrlString(imageUrl: CurrentUserInformation.profileImage)
        changeImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        changeImageView.addGestureRecognizer(tap)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        if let userImage = selectedImage {
            profileImage.image = userImage
        }
        let uniqueName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("Images").child("\(uniqueName).jpg")
        if let uploadData = self.selectedImage?.jpegData(compressionQuality: 0.1) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    guard let url = url else {
                        print("Error downloading image(url is nil)")
                        return
                    }
                    CurrentUserInformation.profileImage = url.absoluteString
                    self.updateProfileImageHandler(url.absoluteString)
                }
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func updateProfileImageHandler(_ url: String) {
        let ref = Constants.FirebaseDB.db.reference().child("users").child(CurrentUserInformation.uid)
        ref.updateChildValues(["profileImage": url])
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageTapped(_ gesture: UIGestureRecognizer) {
        print("hi")
        openImagePicker(.photoLibrary)
    }
    
    func openImagePicker(_ type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = type
        present(picker, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(status: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar(status: true)
    }
    
    @IBAction func passwordButtonPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "UpdatePasswordVC") as! UpdatePasswordVC
        show(controller, sender: nil)
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(identifier: "UpdateEmailVC") as! UpdateEmailVC
        show(controller, sender: nil)
    }
    
}
