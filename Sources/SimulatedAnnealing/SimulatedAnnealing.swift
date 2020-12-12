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
    
    @Option(name: .shortAndLong, help: "Problem type (available types: knapsack")
    var problem: String

    mutating func run() throws {
        guard let problemType = ProblemType(rawValue: problem) else {
            throw SimulatedAnnealingError.invalidProblemType
        }
        
        let engine = createEngine(from: problemType)
        try engine.loadProblems(inputPath, count ?? 1)
        let results = engine.measure()
        
        let avgTime = results.map { $0.time! }.reduce(0.0, +) / Double(results.count)
        let avgError = results.map { $0.error! }.reduce(0.0, +) / Double(results.count)
        print("Average time: \(avgTime)\nAverage error: \(avgError)")
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
