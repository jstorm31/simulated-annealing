//
//  MWSATConfiguration.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 25.12.2020.
//

import Foundation

struct MWSATConfiguration: Configuration {
    let problem: MWSATProblem
    var isSatisfiable = false
    var satisfiableClausesCount = 0
    var weight = 0

    var cost: Int {
        get {
//            if !isSatisfiable {
//                return Int.random(in: 0..<problem.weights.min()!)
//            }

            return satisfiableClausesCount
        }
        set {
            satisfiableClausesCount = newValue
        }
    }
    
    var evaluation: [Bool] {
        didSet {
            cost = calculateCost()
            isSatisfiable = calculateSatisfiability()
            satisfiableClausesCount = calculateSatisfiableFormulasCount()
        }
    }
        
    init(problem: MWSATProblem, evaluation: [Bool]) {
        self.problem = problem
        self.evaluation = evaluation
        weight = calculateCost()
        isSatisfiable = calculateSatisfiability()
        satisfiableClausesCount = calculateSatisfiableFormulasCount()
    }
    
    var randomNeighbour: Configuration {
        let flipPosition = Int.random(in: 0..<evaluation.count)
        var newEvaluation = evaluation
        newEvaluation[flipPosition] = !newEvaluation[flipPosition]

        return MWSATConfiguration(problem: problem, evaluation: newEvaluation)
    }
    
    var description: String {
        return "S: \(cost)\n\(evaluation.map { $0 ? 1 : 0 })"
    }
    
    static func random(for problem: MWSATProblem) -> Self {
        var evaluation = [Bool](repeating: false, count: problem.variableCount)
        
        evaluation = evaluation.map { value in
            return Bool.random() ? !value : value
        }
        
        return MWSATConfiguration(problem: problem, evaluation: evaluation)
    }
    
    private func calculateCost() -> Int {
        return problem.weights.enumerated().map({ evaluation[$0] ? $1 : 0 }).reduce(0, +)
    }
    
    func calculateSatisfiability() -> Bool {
        return problem.formula
            .map { (clause: [Int]) -> Bool in
                clause.map { variable -> Bool in
                    evaluation[abs(variable) - 1] ? variable > 0 : variable < 0
                }.reduce(false) { $0 || $1 }
            }
            .reduce(true) { $0 && $1 }
    }
    
    func calculateSatisfiableFormulasCount() -> Int {
        return problem.formula
            .map { (clause: [Int]) -> Bool in
                clause.map { variable -> Bool in
                    evaluation[abs(variable) - 1] ? variable > 0 : variable < 0
                }.reduce(false) { $0 || $1 }
            }
            .reduce(0) { $1 ? $0 + 1 : $0 }
    }
}
