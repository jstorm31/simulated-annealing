//
//  MWSATEngine.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 26.12.2020.
//

import Foundation

final class MWSATEngine: Engine {
    var problems = [MWSATProblem]()
    
    func loadProblems(_ path: String, _ count: Int) throws {
        let problem = try MWSATProblem.loadProblem(path: path)
        problems.append(problem)
    }
    
    func measure(plot: Bool) -> [SolverResult] {
        var results = [SolverResult]()
        
        for problem in problems {
            let initialState = MWSATConfiguration.random(for: problem)
            let solver = MWSATSolver(initialTemperature: 10, initialState: initialState, coolingCoefficient: 0.995, equilibriumCoefficient: 5)
            
            let start = DispatchTime.now()
            let solution = solver.solve(problem)
            let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000

            results.append(SolverResult(solution: solution, error: nil, time: elapsed))
        }
        
        return results
    }
}
