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
    
    @Option(name: .short, help: "Number of problems to load")
    var count: Int?
    
    @Option(name: .long, help: "Problem type (available types: knapsack")
    var problem: String
    
    @Flag(help: "Generate plot")
    var plot = false

    mutating func run() throws {
        guard let problemType = ProblemType(rawValue: problem) else {
            throw SimulatedAnnealingError.invalidProblemType
        }
        
        print("Solving \(count ?? 1) \(problemType) problems...")
        let engine = createEngine(from: problemType)
        try engine.loadProblems(inputPath, count ?? 1)
        let results = engine.measure(plot: plot)
        
        let times = results.map { $0.time! }
        let avgTime = times.reduce(0.0, +) / Double(results.count)
        let errors = results.map { $0.error! }
        let avgError = errors.reduce(0.0, +) / Double(results.count)
        print("\nFinished\nAverage time: \(avgTime) ms\nMax time: \(times.max()!) ms\nAverage error: \(avgError)\nMax error: \(errors.max()!)")
    }
    
    func createEngine(from problemType: ProblemType) -> Engine {
        switch problemType {
        case .knapsack:
            return KnapsackEngine()
        }
    }
}

enum SimulatedAnnealingError: Error {
    case invalidProblemType
}
