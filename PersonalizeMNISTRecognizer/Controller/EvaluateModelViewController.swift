//
//  EvaluateModelViewController.swift
//  PersonalizeMNISTRecognizer
//
//  Created by Aneesh Prabu on 25/02/20.
//  Copyright © 2020 Aneesh Prabu. All rights reserved.
//

import UIKit
import Vision
import CoreML

class EvaluateModelViewController: UIViewController {

    @IBOutlet weak var digitLabel: UILabel!
    @IBOutlet weak var canvasView: CanvasView!
    
    var requests = [VNRequest]() // holds Image Classification Request
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let visionModel = try? VNCoreMLModel(for: MNISTClassifierApple().model) else {
            fatalError("lmao model is ass")
        }
        
        // create a classification request and tell it to call handleClassification once its done
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        
        self.requests = [classificationRequest] // assigns the classificationRequest to the global requests array
    }
    
    func handleClassification (request:VNRequest, error:Error?) {
        guard let observations = request.results else {print("no results"); return}
        
        // process the ovservations
        let classifications = observations
            .compactMap({$0 as? VNClassificationObservation}) // cast all elements to VNClassificationObservation objects
            .filter({$0.confidence > 0.8}) // only choose observations with a confidence of more than 80%
            .map({$0.identifier}) // only choose the identifier string to be placed into the classifications array
        
        print(classifications)
        DispatchQueue.main.async {
            self.digitLabel.text = classifications.first // update the UI with the classification
        }
        
    }
    

    @IBAction func clearCanvas(_ sender: UIButton) {
        canvasView.clearCanvas()
    }
    
    @IBAction func recognizeDigit(_ sender: UIButton) {
        
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
    
}


