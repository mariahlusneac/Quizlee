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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dogView: UIView!
    @IBOutlet weak var dogImage: UIImageView!
    
    @IBOutlet var buttonsCollection: [UIButton]!
    
    var breedPicker = UIPickerView()
    var userPickedOption = false
    var initialBreedDisplayed = ""
    var allDogBreedsDict = DogRepository.getAllDogsDict()
    var dogBreeds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        
        if userPickedOption == false {
            initialBreedDisplayed = breedButton.titleLabel!.text!
        }
        
        breedPicker.delegate = self
        
        configBreedPicker()
        
        breedButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 15)
        breedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: breedButton.frame.size.width - breedButton.contentEdgeInsets.left - 170, bottom: 16, right: 0)
        
        breedButton.layer.cornerRadius = 15
        dogView.layer.cornerRadius = 22
        
        
        breedTextField.tintColor = .clear
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func configureAppearance() {
        
        dogImage.layer.cornerRadius = 30
        dogImage.layer.masksToBounds = true
//        dogImage.clipsToBounds = true
        
        
        for button in buttonsCollection {
            button.layer.cornerRadius = 16
        }
        
        for dogBreed in allDogBreedsDict {
            dogBreeds.append(dogBreed.key.capitalized)
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        // OPTION 1
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(keyboardFrame)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = contentInset.bottom + keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        // OPTION 1
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    func configBreedPicker() {
        breedTextField.inputView = breedPicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .done
            , target: self, action: #selector(saveBtnClicked))
        
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel
            , target: self, action: #selector(cancelBtnClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([saveBtn, flexibleSpace, cancelBtn], animated: true)
        
        breedTextField.inputAccessoryView = toolbar
    }
    
    @objc func saveBtnClicked() {
        userPickedOption = false
        initialBreedDisplayed = breedButton.titleLabel!.text!
        breedButton.titleLabel?.alpha = 1
        self.view.endEditing(true)
    }
    
    @objc func cancelBtnClicked() {
        self.view.endEditing(true)
        breedButton.setTitle(initialBreedDisplayed, for: .normal)
        breedButton.titleLabel?.alpha = 1
    }
}

extension DogProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userPickedOption = true
        breedButton.setTitle(dogBreeds[row], for: .normal)
        breedButton.titleLabel?.alpha = 0.5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dogBreeds[row]
    }
}

extension DogProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dogBreeds.count
    }
}
