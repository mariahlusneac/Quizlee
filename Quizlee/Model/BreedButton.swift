//
//  BreedButton.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 12/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class BreedButton: UIButton {

    var toolBarView = UIToolbar()
    
    override var inputView: UIToolbar {

        get {
            return self.toolBarView
        }
        set {
            self.toolBarView = newValue
            self.becomeFirstResponder()
        }

    }
    
    override var inputAccessoryView: UIToolbar {
        get {
            return self.toolBarView
        }
        set {
            self.toolBarView = newValue
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

}
