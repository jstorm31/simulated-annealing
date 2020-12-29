//
//  MWSATEngine.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 26.12.2020.
//

import Foundation

final class MWSATEngine: Engine {
    var problems = [(MWSATProblem, MWSATConfiguration?)]()
    
    func loadProblems(_ path: String, _ count: Int, _ solutionPath: String?) throws {
        let fullPath = NSString(string: path).expandingTildeInPath
        let problemPaths = try FileManager.default.contentsOfDirectory(atPath: fullPath)
        var i = 0
        var j = 0
        
        while i < count && j < problemPaths.count {
            let problemPath = fullPath + "/" + problemPaths[j]
            let problem = try MWSATProblem.loadProblem(path: problemPath)
            var solution: MWSATConfiguration?
            
            if let solutionPath = solutionPath {
                solution = try MWSATProblem.loadSolution(solutionPath, problem)
            }
            
            // Only add problems with solutions
            if solution != nil {
                problems.append((problem, solution))
                i += 1
            }
            j += 1
        }
    }
    
    func measure(plot: Bool, _ initialTemperature: Double?) -> [SolverResult] {
        var results = [SolverResult]()
        var temperatures = [Double]()
        
        for (problem, referenceSolution) in problems {
            let initialState = MWSATConfiguration.random(for: problem)
            let solver = MWSATSolver(initialTemperature: 512.0, initialState: initialState, coolingCoefficient: 0.98, equilibriumCoefficient: 1)
            
            let start = DispatchTime.now()
//            solver.initialTemperature = solver.temperatureTunning()
            temperatures.append(solver.initialTemperature)
            let solution = solver.solve(problem, plot: plot)
            let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
            
            var error: Double?
            if let referenceSolution = referenceSolution {
                error = solver.measureError(solution, referenceSolution)
            }

            results.append(SolverResult(solution: solution, error: error, time: elapsed))
        }
        
        return results
    }
}
