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
        var directoryParts = NSString(string: path).expandingTildeInPath.split(separator: "/")
        directoryParts = Array(directoryParts[0...directoryParts.index(directoryParts.endIndex, offsetBy: -2)])
        let directoryPath = "/" + directoryParts.joined(separator: "/")
        let problemPaths = try FileManager.default.contentsOfDirectory(atPath: directoryPath)
        
        for i in 0..<count {
            let problemPath = directoryPath + "/" + problemPaths[i]
            let problem = try MWSATProblem.loadProblem(path: problemPath)
            var solution: MWSATConfiguration?
            
            if let solutionPath = solutionPath {
                solution = try MWSATProblem.loadSolution(solutionPath, problem)
            }
            problems.append((problem, solution))
        }
    }
    
    func measure(plot: Bool) -> [SolverResult] {
        var results = [SolverResult]()
        
        for (problem, referenceSolution) in problems {
            let initialState = MWSATConfiguration.random(for: problem)
            let solver = MWSATSolver(initialTemperature: 5, initialState: initialState, coolingCoefficient: 0.995, equilibriumCoefficient: 1)
            
            let start = DispatchTime.now()
            let solution = solver.solve(problem)
            let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
            
            var error: Double?
            if let referenceSolution = referenceSolution {
                error = solver.measureError(solution, referenceSolution)
            }

            results.append(SolverResult(solution: solution, error: error, time: elapsed))
        }
        
        print(results.first!.solution)
        return results
    }
}
