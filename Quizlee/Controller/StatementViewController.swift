//
//  ViewController.swift
//  Quizlee
//
//  Created by Razvan Apostol on 01/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit


protocol QuizDelegate: class {
    func userDidAnswerQuestions(atIndex: Int, withCorrectAnswer answer: Bool)
}

class StatementViewController: UIViewController {

    var statement: Statement!
    var itemIndex: Int!
    var totalItems: Int!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var trueButton: StatementButton!
    @IBOutlet weak var falseButton: StatementButton!
    @IBOutlet weak var progressLabel: UILabel!
    
    weak var delegate: QuizDelegate?
    
    @IBAction func onStatementResponse(_ sender: UIButton) {
        delegate?.userDidAnswerQuestions(atIndex: itemIndex, withCorrectAnswer: evaluate(statement: statement, answer: sender == trueButton))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupButtons()
        update(withStatement: statement, atIndex: itemIndex, inTotal: totalItems)
    }
    
    func setupButtons() {
        trueButton.configure(withButtonType: .truth)
        falseButton.configure(withButtonType: .falsity)
    }
    
    func update(withStatement statement: Statement, atIndex index: Int, inTotal total: Int) {
        questionLabel.text = statement.statementText
        progressLabel.text = "\(index+1)/\(total)"
        
    }
    
    fileprivate func evaluate(statement: Statement, answer: Bool) -> Bool{
        return statement.isTrue == answer ? true : false
    }
    
}
