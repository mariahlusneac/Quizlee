//
//  StatementPool.swift
//  Quizlee
//
//  Created by Maria Hlusneac on 02/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct StatementPool {
    
    private var pool: [Statement]
    
    init(data: Dictionary<String, AnyObject>) {
        pool = [Statement]()
        if let statementsCollection = data["statements"] as? [[String: AnyObject]] {
            statementsCollection.forEach( {
//                print("statement: \($0)")
                if let statementText = $0["statement"] as? String, let truth = $0["isTrue"] as? Bool {
                    let statement = Statement(statementText: statementText, isTrue: truth)
                    pool.append(statement)
                }
            } )
        }
    }
    
    func getQuizQuestions() -> [Statement] {
        var results = [Statement]()
        if pool.count >= 10 {
            var poolCopy = pool
            while results.count < 10 {
                let selectedIndex = Int.random(in: 0..<poolCopy.count)
                results.append(poolCopy[selectedIndex])
                poolCopy.remove(at: selectedIndex)
            }
            return results
        }
        return pool
    }
}
