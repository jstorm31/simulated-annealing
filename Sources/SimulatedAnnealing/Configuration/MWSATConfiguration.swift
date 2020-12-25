//
//  MWSATConfiguration.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 25.12.2020.
//

import Foundation

struct MWSATConfiguration: Configuration {
    let problem: MWSATProblem
    let evaluation: [Bool]
    let cost: Int
    
    init(problem: MWSATProblem, evaluation: [Bool]) {
        self.problem = problem
        self.evaluation = evaluation
        self.cost = problem.weights.enumerated().map({ evaluation[$0] ? $1 : 0 }).reduce(0, +)
    }
    
    var isSatisfiable: Bool {
        return problem.formula
            .map { (clause: [Int]) -> Bool in
                clause.enumerated().map { (i, variable) -> Bool in
                    evaluation[i] ? variable > 0 : variable < 0
                }.reduce(true) { $0 || $1 }
            }
            .reduce(true) { $0 && $1 }
    }
    
    var randomNeighbour: Configuration {
        let flipPosition = Int.random(in: 0...(evaluation.count - 1))
        var newEvaluation = evaluation
        newEvaluation[flipPosition] = !newEvaluation[flipPosition]

        return MWSATConfiguration(problem: problem, evaluation: newEvaluation)
    }
    
    var description: String {
        return "S: \(cost)\n\(evaluation.map { $0 ? 1 : 0 })"
    }

    func isBetter(than configuration: Configuration) -> Bool {
        return cost > configuration.cost
    }
}
