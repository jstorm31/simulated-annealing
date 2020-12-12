//
//  KnapsackEngine.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 12.12.2020.
//

import Foundation
import SwiftPlot

final class KnapsackEngine: Engine {
    var problems = [KnapsackProblem]()
    
    func loadProblems(_ path: String, _ count: Int) throws {
        problems = try KnapsackProblem.loadProblems(path: path, count: count)
    }
    
    func measure(plot: Bool) -> [SolverResult] {
        var results = [SolverResult]()
        
        for (i, problem) in problems.enumerated() {
            print("Solving problem: \(i)")
            let result = measure(problem, plot)
            print("Result: \(result.solution)\n")
            results.append(result)
        }
        
        return results
    }
    
    func measure(_ problem: KnapsackProblem, _ plot: Bool) -> SolverResult {
        let initialState = GreedySolver().solve(problem)
        let solver = KnapsackSolver(initialState: initialState, initialTemperature: 10, coolingCoefficient: 0.995, equilibriumCoefficient: 2)
        
        let start = DispatchTime.now()
        solver.temperatureTunning()
        let solution = solver.solve(problem, plot: plot)
        let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
        let error = solver.measureError(problem, solution as! KnapsackConfiguration)
        
        return SolverResult(solution: solution, error: error, time: elapsed)
    }
}
