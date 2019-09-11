//
//  ButtonCollectionViewCell.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 13/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var characTraitButton: UIButton!
    
    override var isSelected: Bool {
        didSet {
            characTraitButton.backgroundColor = isSelected ? UIColor(displayP3Red: 0.956, green: 0.439, blue: 0.243, alpha: 1) : UIColor(displayP3Red: 0.898, green: 0.9, blue: 0.925, alpha: 1)
            characTraitButton.titleLabel?.textColor = isSelected ? .white : UIColor(displayP3Red: 0.709, green: 0.721, blue: 0.78, alpha: 1)
        }
    }
    
    var viewmodel: ButtonCollectionViewCellViewModel! {
        didSet {
            characTraitButton.titleLabel?.text = viewmodel.characTraitString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
}
