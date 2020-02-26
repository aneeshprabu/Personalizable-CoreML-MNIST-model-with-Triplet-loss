//
//  ViewController.swift
//  PersonalizeMNISTRecognizer
//
//  Created by Aneesh Prabu on 24/02/20.
//  Copyright © 2020 Aneesh Prabu. All rights reserved.
//

import UIKit
import Eureka

class ViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        form +++ Section("Dataset")
            <<< ButtonRow(){ row in
                row.title = "Add dataset"
            }.onCellSelection({ (cell, row) in
                self.performSegue(withIdentifier: "goToAddDataset", sender: self)
            })
            
            <<< ButtonRow(){ row in
                row.title = "Train"
            }
        form +++ Section("Test")
            <<< SwitchRow("switchRowTag"){
                $0.title = "Use CreateML MNIST"
            }
            <<< ButtonRow(){

            $0.hidden = Condition.function(["switchRowTag"], { form in
                return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
            })
            $0.title = "Test CreateML Model"
            }.onCellSelection({ (cell, row) in
                self.performSegue(withIdentifier: "goToEvaluateModel", sender: self)
            })
            
            <<< ButtonRow(){ row in
                row.title = "Evaluate"
            }.onCellSelection({ (cell, row) in
                self.performSegue(withIdentifier: "goToCustomModel", sender: self)
            })
            
            
            

        +++ Section("Delete")
            <<< ButtonRow(){
                $0.title = "Clear dataset"
            }.onCellSelection({ (cell, row) in
                resultDictionary.removeAll()
                
                let alert = UIAlertController(title: "Cleared!", message: "Dataset is cleared. Add new dataset by clicking 'Add dataset'", preferredStyle: .alert)
                               let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                               alert.addAction(action)
                               self.present(alert, animated: true, completion: nil)
            })
        
    }


}

