//
//  DogTableViewCell.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class DogTableViewCell: UITableViewCell {

    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var breedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func config(withDogBreed breed: DogBreed) {
        breedLabel.text = breed.dogBreed
    }
    
}
