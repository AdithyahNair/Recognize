//
//  ViewController.swift
//  Recognize
//
//  Created by Adithyah Nair on 10/05/22.
//

import UIKit
import CoreML
import Vision

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.allowsEditing = true

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                
                fatalError("UIImage not converted to CIImage")
                
            }
            
            detect(image: ciImage)
            
        }
    
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: .init(contentsOf: Inceptionv3.urlOfModelInThisBundle)) else {
            
            fatalError("Model not found.")
            
        }
        
        let request = VNCoreMLRequest(model: model, completionHandler: nil)
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            
            try handler.perform([request])
            
        } catch {
            
            print("Handler cannot perform request.")
            
        }
        
        
        
        
    }
    
}

