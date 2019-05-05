//
//  SaveViewController.swift
//  App2
//
//  Created by Robin on 28/04/2019.
//  Copyright © 2019 Robin. All rights reserved.
//

import UIKit

class SaveViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var titelTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
  
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var uploadbtn: UIButton!
    @IBAction func saveButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Sparar bild...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        
        if let validCord = SaveData.shared.savedCord, let titelText = self.titelTextField.text {
                if let img = self.imageView.image, let imgData = img.pngData() {
                    self.present(alert, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                        let trip = SavedTrip(destination: validCord, titel: titelText, image: imgData)
                        SaveData.shared.tripsArray.append(trip)
                        SaveData.shared.save()
                        self.dismiss(animated: false, completion: nil)
                        self.showToast(message: "Klar")
                    }
                }else {
                    self.dismiss(animated: false, completion: nil)
                    let alert = UIAlertController(title: "Ingen bild vald", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    
    @IBAction func uploadButton(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Välj källa", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                image.sourceType = UIImagePickerController.SourceType.camera
                 self.present(image, animated: true)
            }else {
                let alert = UIAlertController(title: "No camera found on device", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Bibliotek", style: .default, handler: { (action) in
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
             self.present(image, animated: true)
            
        }))
        present(actionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SaveData.shared.loadCord()
        self.view.backgroundColor = UIColor(named: "bakgroundColor")
        SaveData.shared.buttonDesign(button: uploadbtn)
        SaveData.shared.buttonDesign(button: savebtn)
        // Do any additional setup after loading the view.
    }

}
