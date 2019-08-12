//
//  DogProfileViewController.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 09/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogProfileViewController: UIViewController {

    
    @IBOutlet weak var breedButton: BreedButton!
    @IBOutlet weak var breedTextField: UITextField!
    
    var breedPicker = UIPickerView()
    
    var urgency = ["low", "medium", "high"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBreedPicker()
        breedPicker.delegate = self
        
        breedButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 15)
        
        breedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: breedButton.frame.size.width - breedButton.contentEdgeInsets.left - 170, bottom: 16, right: 0)
    }
    
    func configBreedPicker() {
        
        breedTextField.inputView = breedPicker
        
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        var saveBtn = UIBarButtonItem(barButtonSystemItem: .done
            , target: self, action: #selector(saveBtnClicked))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel
            , target: self, action: #selector(cancelBtnClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([saveBtn, flexibleSpace, cancelBtn], animated: true)
        
        breedTextField.inputAccessoryView = toolbar

    }
    
    @objc func saveBtnClicked() {
//        breedButton.
        
//        breedPicker.text = formatter.string(from: datePicker.date)
//        //        dueDateTextField.text = "\(datePicker.date)"
//        print("Done clicked: value \(datePicker.date)")
    }
    
    @objc func cancelBtnClicked() {
        self.view.endEditing(true)
        print("Cancel clicked")
    }
    
}


extension DogProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        breedPicker. = "Level of Urgency is \(urgency[row])"
        print("Am selectat row-ul \(row) din componenta \(component)")
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return urgency[row]
    }
}


extension DogProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return urgency.count
    }
}
