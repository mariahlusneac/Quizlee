//
//  BreedDetailCollectionViewCell.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class BreedDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config (nameImage: String) {
        detailImageView.image = UIImage(named: nameImage)
    }
}
