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
        let problems = try KnapsackProblem.loadProblems(path: inputPath, count: 10)
        var results = [SolverResult]()
        var i = 0
        
        for problem in problems {
            print("Solving problem: \(i)")
            i += 1
//            let initialState = KnapsackConfiguration.randomSolution(for: problem)
            let initialState = GreedySolver().solve(problem)
            let solver = KnapsackSolver(initialState: initialState, initialTemperature: 100.0, coolingCoefficient: 0.995, equilibriumCoefficient: 10)
            
            let start = DispatchTime.now()
            solver.temperatureTunning()
            let solution: KnapsackConfiguration = solver.solve(problem) as! KnapsackConfiguration
            let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
            let error = solver.measureError(problem, solution)
            
            results.append(SolverResult(solution: solution, error: error, time: elapsed))
        }
        
        let avgTime = results.map { $0.time! }.reduce(0.0, +) / Double(results.count)
        let avgError = results.map { $0.error! }.reduce(0.0, +) / Double(results.count)
        print("Average time: \(avgTime)\nAverage error: \(avgError)")
    }
}
