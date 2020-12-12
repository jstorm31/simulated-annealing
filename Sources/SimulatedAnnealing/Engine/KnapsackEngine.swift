//
//  KnapsackEngine.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 12.12.2020.
//

import Foundation

final class KnapsackEngine: Engine {
    var problems = [KnapsackProblem]()
    
    func loadProblems(_ path: String, _ count: Int) throws {
        problems = try KnapsackProblem.loadProblems(path: path, count: count)
    }
    
    func measure() -> [SolverResult] {
        var results = [SolverResult]()
        
        for problem in problems {
            let result = measure(problem)
            results.append(result)
        }
        
        return results
    }
    
    func measure(_ problem: KnapsackProblem) -> SolverResult {
        let initialState = GreedySolver().solve(problem)
        let solver = KnapsackSolver(initialState: initialState, initialTemperature: 100.0, coolingCoefficient: 0.995, equilibriumCoefficient: 10)
        
        let start = DispatchTime.now()
        solver.temperatureTunning()
        let solution: KnapsackConfiguration = solver.solve(problem) as! KnapsackConfiguration
        let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
        let error = solver.measureError(problem, solution)
        
        return SolverResult(solution: solution, error: error, time: elapsed)
    }
}
