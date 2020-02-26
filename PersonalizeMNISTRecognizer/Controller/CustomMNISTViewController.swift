//
//  CustomMNISTViewController.swift
//  PersonalizeMNISTRecognizer
//
//  Created by Aneesh Prabu on 25/02/20.
//  Copyright © 2020 Aneesh Prabu. All rights reserved.
//

import UIKit
import Vision
import CoreML



class CustomMNISTViewController: UIViewController {

    @IBOutlet weak var digitLabel: UILabel!
    @IBOutlet weak var canvasView: CanvasView!
    
    var requests = [VNRequest]() // holds Image Classification Request
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let visionModel = try? VNCoreMLModel(for: mnist().model) else {
            fatalError("lmao model is ass")
        }
        
        // create a classification request and tell it to call handleClassification once its done
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        
        self.requests = [classificationRequest] // assigns the classificationRequest to the global requests array
    }
    
    func handleClassification (request:VNRequest, error:Error?) {
        guard let observations = request.results else {print("no results"); return}
        //print(observations)
        
        // process the ovservations
        let classifications = observations
            .compactMap({$0 as? VNCoreMLFeatureValueObservation}) // cast all elements to VNClassificationObservation objects
             // only choose observations with a confidence of more than 80%
            .map({$0.featureValue.multiArrayValue}) // only choose the identifier string to be placed into the classifications array
        
        
        if let result = classifications.first {
            print("----------------TEST DATA--------------------")
            print(result as Any)
            
            var predictionLabel = "0"
            var minValue : Double = 10000.0
            
            for key in resultDictionary.keys {
                let vector2 = resultDictionary[key]
                let dist = distance(vector1: result!, vector2: vector2!)
                print("Distance: \(dist)")
                if dist <= minValue {
                    minValue = dist
                    predictionLabel = key
                }
            }
            
            print("Minimum value: \(minValue)")
            DispatchQueue.main.async {
                        self.digitLabel.text = "\(predictionLabel)" // update the UI with the classification
            }
        }
    }
    
    ///Function to find distance between two MLMultiArray
    private func distance(vector1: MLMultiArray, vector2: MLMultiArray) -> Double {
        var sum: Double = 0.0
        for i in 0..<vector1.count {
            let temp = pow(((vector1[i] as! Double) - (vector2[i] as! Double)), 2)
            sum += temp
        }
        return sqrt(sum)
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


