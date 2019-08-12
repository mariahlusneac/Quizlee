//
//  StatementButton.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 02/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

enum StatementButtonType {
    case truth
    case falsity
    case start
    case reset
    
    var cornerRadius: CGFloat { return 5 }
    var borderWidth: CGFloat { return 2 }
    var borderColor: CGColor {
        switch self {
        case .truth:
            return UIColor.green.cgColor
        case .falsity:
            return UIColor.red.cgColor
        case .start:
            return UIColor.blue.cgColor
        default:
            return UIColor.magenta.cgColor
            
        }
    }
    
    var titleText: String {
        switch self {
        case .truth:
            return "TRUE"
        case .falsity:
            return "FALSE"
        case .start:
            return "START"
        default:
            return "RESET"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .truth:
            return .green
        case .falsity:
            return .red
        default:
            return .blue
        }
    }
}

class StatementButton: UIButton {

    func configure(withButtonType type: StatementButtonType) {
        layer.cornerRadius = type.cornerRadius
        layer.borderWidth = type.borderWidth
        layer.borderColor = type.borderColor
        //        trueButton.layer.masksToBounds = true
        setTitle(type.titleText, for: .normal)
        setTitleColor(type.titleColor, for: .normal)
    }

}
