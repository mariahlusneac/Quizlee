//
//  BreedSectionHeaderView.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class BreedSectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewmodel: BreedSectionHeaderViewModel! {
        didSet {
            nameLabel.text = viewmodel.breedName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHeader(gestureRecognizer:)))
        addGestureRecognizer(tap)
    }
    
    @objc func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let newViewController = (storyboard.instantiateViewController(withIdentifier: "BreedDetailsVC") as? BreedDetailsViewController)!
//        navigationController?.pushViewController(newViewController, animated: true)
//        present(newViewController, animated: true)
    }
}
