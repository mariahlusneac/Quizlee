//
//  DogCollectionViewCell.swift
//  CollectionViewExample
//
//  Created by George Galai on 08/08/2019.
//  Copyright © 2019 George Galai. All rights reserved.
//

import UIKit

class DogCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            dogImageView.layer.borderWidth = isSelected ? 5 : 0
        }
    }
    
    var viewmodel: DogCollectionViewCellViewModel! {
        didSet {
            dogNameLabel.text = viewmodel.dogNameString
        }
    }
    
    var dog: Dog! {
        didSet {
            dogImageView.image = dog.image
//            dogNameLabel.text = dog.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 22
        contentView.layer.borderColor = UIColor.orange.cgColor
        contentView.layer.masksToBounds = true
    }
}
