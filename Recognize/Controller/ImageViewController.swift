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
        
        imagePicker.sourceType = .camera
        
        imagePicker.allowsEditing = true

    }
    
    //MARK: - UIImagePickerControllerDelegate Method
    
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
    
    //MARK: - @IBAction func cameraTapped(_ sender: UIBarButtonItem)

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    //MARK: - detect(image: CIImage)
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: .init(contentsOf: Inceptionv3.urlOfModelInThisBundle)) else {
            
            fatalError("Model not found.")
            
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in  // this completion handler gets trigger once the handler has performed the request.
            
            guard let results = request.results as? [VNClassificationObservation] else {
                
                fatalError("Request failed to produce results.")
                
            }
            
            if let firstResult = results.first {
                
                print(results)
                
                self.title = firstResult.identifier.contains("hotdog") ? "Is a Hotdog" : "Is not a Hotdog"
                
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            
            try handler.perform([request])
            
        } catch {
            
            print("Handler cannot perform request.")
            
        }
 
    }
    
}

