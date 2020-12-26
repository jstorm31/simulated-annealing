//
//  MWSATEngine.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 26.12.2020.
//

import Foundation

final class MWSATEngine: Engine {
    var problems = [MWSATProblem]()
    
    func loadProblems(_ path: String, _ count: Int, _ solutionPath: String?) throws {
        let problem = try MWSATProblem.loadProblem(path: path)
        
        if let solutionPath = solutionPath {
            let solution = try MWSATProblem.loadSolution(solutionPath, problem)
            print(solution)
        }
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
        
        print(results.first!.solution)
        return results
    }
}
