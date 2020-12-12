//
//  SimulatedAnnealing.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation
import ArgumentParser

struct SimulatedAnnealing: ParsableCommand {
    @Option(name: .short, help: "An input file path with problems relative to Data directory")
    var inputPath: String

    mutating func run() throws {
        let problems = try KnapsackProblem.loadProblems(path: inputPath, count: 1)
        
        for problem in problems {
            let initialState = KnapsackConfiguration.randomSolution(for: problem)
            let solver = KnapsackSolver(initialState: initialState, initialTemperature: 100.0, coolingCoefficient: 0.995, equilibriumCoefficient: 100)
            
            let start = DispatchTime.now()
            solver.temperatureTunning()
            let solution: KnapsackConfiguration = solver.solve(problem) as! KnapsackConfiguration
            let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
            let error = solver.measureError(problem, solution)
            let result = SolverResult(solution: solution, error: error, time: elapsed)
            
            print(result)
        }
    }
}
