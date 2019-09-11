////
////  InitialViewController.swift
////  Quizlee
////
////  Created by Maria Hlusneac on 02/08/2019.
////  Copyright © 2019 Endava Internship 2019. All rights reserved.
////
//
//import UIKit
//
//class InitialViewController: UIViewController {
//
//    var coordinator: QuizCoordinator!
//
//    @IBOutlet weak var startButton: StatementButton!
//
//
//
//    @IBAction func startQuiz(_ sender: Any) {
//        if let json =  DogRepository.dataFromJSON(withName: DogRepository.statementsFilename) {
//            let pool = StatementPool(data: json)
//            let statements = pool.getQuizQuestions()
//            coordinator = QuizCoordinator(statements: statements)
//            coordinator.flowDelegate = self
//            coordinator.startQuiz()
//        }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        startButton.configure(withButtonType: .start)
//    }
//
//}
//
//
//
//extension InitialViewController: QuizFlowDelegate {
//    func willStartQuiz(insideNavigationController: UINavigationController) {
//        present(insideNavigationController, animated: true, completion: nil)
//    }
//
//    func didFinishQuiz() {
//        print("did finish quiz")
//        dismiss(animated: true, completion: nil)
//    }
//}




import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var startButton: StatementButton!
    
    var score: Int = 0
    var coordinator: QuizCoordinator!
    var myTabBarControler: UITabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setupButtons()
    }
    
//    func setupButtons() {
//        startButton.configure(withButtonType: .begin)
//    }
    
    
    @IBAction func startQuiz(_ sender: Any) {
        if let json =  DogRepository.dataFromJSON(withName: DogRepository.statements2Filename) {
            let pool = StatementPool(data: json)
            let statements = pool.getQuizQuestions()
            coordinator = QuizCoordinator(statements: statements)
            coordinator.flowDelegate = self
            coordinator.startQuiz()
        }
    }
    
}

extension InitialViewController: QuizFlowDelegate {
    func didFinishQuiz() {
        print("did finish quiz")
        dismiss(animated: true, completion: nil)
    }
    
    func willStartQuiz(insideNavigationController: UINavigationController) {
        present(insideNavigationController, animated: true, completion: nil)
    }
}



