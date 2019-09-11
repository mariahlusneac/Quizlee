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
    @IBOutlet weak var characCollectionView: UICollectionView!
    
    @IBOutlet var buttonsCollection: [UIButton]!
    
    var numberOfClicks = 0
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        numberOfClicks += 1
        if numberOfClicks % 2 == 1 {
            sender.backgroundColor = UIColor(displayP3Red: 0.96, green: 0.439, blue: 0.243, alpha: 1)
            sender.setTitleColor(.white, for: .normal)
        }
        else {
            sender.backgroundColor = UIColor(displayP3Red: 0.898, green: 0.9, blue: 0.92, alpha: 1)
            sender.titleLabel?.textColor = UIColor(displayP3Red: 0.709, green: 0.721, blue: 0.78, alpha: 1)
        }
    }
    
    var breedPicker = UIPickerView()
    var userPickedOption = false
    var initialBreedDisplayed = ""
    var allDogBreedsDict = DogRepository.getAllDogsDict()
    var dogBreeds = [String]()
    
    let defaultSpace: CGFloat = 8
    let numberOfColumns: CGFloat = 2
    
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
        
        characCollectionView.delegate = self
        characCollectionView.dataSource = self
        characCollectionView.register(UINib(nibName: "ButtonCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ButtonCollectionViewCell")
        
        characCollectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:))))
        
        characCollectionView.allowsMultipleSelection = true
        
        let layout: UICollectionViewFlowLayout = characCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
//        characCollectionView.collectionViewLayout.invalidateLayout()
 
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        characCollectionView.collectionViewLayout.invalidateLayout()
        for button in buttonsCollection {
            button.backgroundColor = UIColor(displayP3Red: 0.898, green: 0.9, blue: 0.92, alpha: 1)
            button.titleLabel?.textColor = UIColor(displayP3Red: 0.709, green: 0.721, blue: 0.78, alpha: 1)
        }
    }
    
    @objc func handleLongGesture(gesture:UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = characCollectionView.indexPathForItem(at: gesture.location(in: characCollectionView))
                else { break }
            characCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            characCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            characCollectionView.endInteractiveMovement()
        default:
            characCollectionView.cancelInteractiveMovement()
        }
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
    
    
    ///////////////////////  Character Collection View  ///////////////////////
    
    
    
    
    var characterTraits = ["PLAYFUL", "CHEERFUL", "ACTIVE", "FRIENDLY", "CURIOUS", "QUIET", "PEACEFUL", "LOUD", "SILLY", "LAZY", "CHILLY", "CLUMSY", "FUNNY"]
    
    var selectedItems = [String]()
    
//    override func viewWillLayoutSubviews() {
//
//        super.viewWillLayoutSubviews()
//
//        characCollectionView.collectionViewLayout.invalidateLayout()
//
//    }

    
    ///////////////////////  Character Collection View  ///////////////////////
}


extension DogProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.frame.size.width - defaultSpace - collectionView.contentInset.left - collectionView.contentInset.right) / numberOfColumns
            let height: CGFloat = 30

            return CGSize(width: width, height: height)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return defaultSpace
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return defaultSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let aux = characterTraits.remove(at: sourceIndexPath.item)
        characterTraits.insert(aux, at: destinationIndexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let characTrait = characterTraits[indexPath.row]
        selectedItems.append(characTrait)
        print(selectedItems)

        print(indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as! ButtonCollectionViewCell
//        cell.characTraitButton.backgroundColor = .orange
//        cell.characTraitButton.titleLabel?.textColor = .white
        cell.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if selectedItems.count < 3 {
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let characTrait = characterTraits[indexPath.row]
        guard let index = selectedItems.firstIndex(of: characTrait) else {
            return
        }
        selectedItems.remove(at: index)
        
        print(indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as! ButtonCollectionViewCell
//        cell.characTraitButton.backgroundColor = .lightGray
//        cell.characTraitButton.titleLabel?.textColor = .gray
        
        cell.isSelected = false
    }
    
    
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        characCollectionView.reloadData()
//    }
}



extension DogProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterTraits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as! ButtonCollectionViewCell
        
        let characterTrait = characterTraits[indexPath.row]
        cell.characTraitButton.setTitle(characterTrait, for: .normal)
        
        if selectedItems.contains(characterTrait) {
            cell.isSelected = true
        }
        
        return cell
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
