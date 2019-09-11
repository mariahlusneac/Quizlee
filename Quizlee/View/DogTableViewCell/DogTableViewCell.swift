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
    }
    
    var viewmodel: DogTableViewCellViewModel? {
        didSet {
            breedLabel.text = viewmodel?.name
//            breedImage.image = UIImage(data: try! Data(contentsOf: URL(string: viewmodel.image.imageURL)!))
            
            // Stop loader (ActivityIndicator)
        }
    }
    
//    func config(withDogBreed breed: DogBreed) {
//        breedLabel.text = breed.dogBreed
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewmodel = nil
        // Start a loader (Activity Indicator)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.contentView.backgroundColor = .lightGray
            }
            else {
                self.contentView.backgroundColor = .white
            }
        }
    }
}
