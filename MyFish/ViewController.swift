//
//  ViewController.swift
//  MyFish
//
//  Created by Valeria Heikkila on 2020/06/24.
//  Copyright © 2020 Valeria Heikkila. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //let user pick an image
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            //convert image to CIImage format which is compatible with CoreML
            guard let convertedCIImage = CIImage(image: userPickedImage) else{
                fatalError("Cannot convert to CIImage.")
            }
            //pass converted image to the model
            predict(image: convertedCIImage)
            imageView.image = userPickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func predict(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: ml().model) else{
            fatalError("Cannot import model.")
        }
        
        //send request for prediction
        let request = VNCoreMLRequest(model: model) { (request, error) in
            //receive prediction result
            let classification = request.results?.first as? VNClassificationObservation
            var result = classification?.identifier
            var percent = classification?.confidence
            if result == "aji"{
                result = "あじ"
            }
            if result == "tako"{
                result = "たこ"
            }
            if result == "ika"{
                result = "いか"
            }
            if result == "tai"{
                result = "たい"
            }
            if result == "salmon"{
                result = "サーモン"
            }
            if result == "iwashi"{
                result = "いわし"
            }
            if result == "maguro"{
                result = "マグロ"
            }
            if result == "sanma"{
                result = "さんま"
            }
            if result == "katsuo"{
                result = "かつお"
            }
            if result == "saba"{
                result = "さば"
            }
            //set prediction string as a title of navi-bar
            self.resultLabel.text = "  \(result!) \n  \(Int(percent! * 100))%"
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
        try handler.perform([request])
        }
        catch{
            print(error)
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
        
        
    }
}

