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
            let solver = KnapsackSolver(initialTemperature: 100.0, coolingCoefficient: 0.995, equilibriumCoefficient: 100)
            let solution = solver.solve(problem: problem, initialState: KnapsackConfiguration.randomSolution(for: problem))
            print(solution)
        }
    }
}
