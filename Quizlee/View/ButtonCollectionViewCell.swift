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
            characTraitButton.backgroundColor = isSelected ? .orange : .lightGray
        }
    }
    
    var buttonText: String! {
        didSet {
            characTraitButton.titleLabel?.text = buttonText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        // Initialization code
    }

}
