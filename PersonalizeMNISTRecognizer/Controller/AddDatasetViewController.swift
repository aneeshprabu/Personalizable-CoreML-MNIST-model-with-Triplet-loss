//
//  AddDatasetViewController.swift
//  PersonalizeMNISTRecognizer
//
//  Created by Aneesh Prabu on 25/02/20.
//  Copyright © 2020 Aneesh Prabu. All rights reserved.
//

import UIKit
import CoreML
import Vision

//MARK: - Globul declaration
///Globul
var resultDictionary = [String: MLMultiArray]()


//MARK: - Main class declaration
class AddDatasetViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var numberTextField: UITextField!
    
    
    var requests = [VNRequest]() // holds Image Classification Request
    
    
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        ///Hide the keyboard when pressing anywhere else on the screen.
        self.setupToHideKeyboardOnTapOnView()
        
        ///Disable save button. Only appear when textfield is editing.
        saveBtn.isEnabled = true
        
        guard let visionModel = try? VNCoreMLModel(for: mnist().model) else {
            fatalError("lmao model is ass")
        }
        
        // create a classification request and tell it to call handleClassification once its done
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        
        self.requests = [classificationRequest] // assigns the classificationRequest to the global requests array
    }
    
    
    //MARK: - Handle Classification
    
    func handleClassification (request:VNRequest, error:Error?) {
            guard let observations = request.results else {print("no results"); return}
            //print(observations)
            
        // process the ovservations
        let classifications = observations
            // cast all elements to VNClassificationObservation objects
            .compactMap({$0 as? VNCoreMLFeatureValueObservation})
            // only choose the identifier string to be placed into the classifications array
            .map({$0.featureValue.multiArrayValue})
        
        if let resultArr = classifications.first {
            if let labelText = numberTextField.text {
                resultDictionary[labelText] = resultArr
                
                let alert = UIAlertController(title: "Saved", message: "Image was saved with label \(labelText)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                ///Error for empty textfield
                let alert = UIAlertController(title: "Please fill label", message: "Textfield cannot be empty.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                              
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }else {
            ///Error for empty classification results
            let alert = UIAlertController(title: "Cannot identify number", message: "The model gave a empty array value.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                          
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        ///Print classification results
        print("----------------------------Training DATA----------------------------")
        print(resultDictionary)
        
        canvasView.clearCanvas()
        numberTextField.text = ""
        
        
    }
    
    
    //MARK: - Save function pressed

    ///When bar button "Save" is pressed.
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        ///Get image from canvas and scale it
        let image = UIImage(view: canvasView)
        let scaledImage = scaleImage(image: image, toSize: CGSize(width: 28, height: 28))
        
        /// create a handler that should perform the vision request
        let imageRequestHandler = VNImageRequestHandler(cgImage: scaledImage.cgImage!, options: [:])
        
        do {
            try imageRequestHandler.perform(self.requests)
        }catch{
            print(error)
        }
        
    }
    
    
    //MARK: - Scale image function
    
    func scaleImage (image: UIImage, toSize size: CGSize) -> UIImage {
        
        ///Starting image context
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        ///Changing image size from the context
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        ///get the image from context
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        ///Ending image context
        
        return newImage!
        
    }
    
    //MARK: - Clear canvas
    
    ///Clears the canvas
    @IBAction func clearCanvas(_ sender: UIButton) {
        canvasView.clearCanvas()
    }
    
}













///Extension of UIViewController for hiding keyboard.
extension UIViewController
{
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
