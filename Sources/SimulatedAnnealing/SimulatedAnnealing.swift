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
    
    @Option(name: .short, help: "A file with solutions")
    var solutionPath: String?
    
    @Option(name: .short, help: "Number of problems to load")
    var count: Int?
    
    @Option(name: .long, help: "Problem type (available types: knapsack, mwsat")
    var problem: String
    
    @Option(name: .long)
    var initialTemperature: Double?
    
    @Flag(help: "Generate plot")
    var plot = false

    mutating func run() throws {
        guard let problemType = ProblemType(rawValue: problem) else {
            throw SimulatedAnnealingError.invalidProblemType
        }
        
//        print("Solving \(count ?? 1) \(problemType) problems...")
        let engine = createEngine(from: problemType)
        try engine.loadProblems(inputPath, count ?? 1, solutionPath)
        let results = engine.measure(plot: plot, initialTemperature)

        let instanceId = inputPath.split(separator: "/").last!
        let times = results.compactMap { $0.time }
        let avgTime = times.reduce(0.0, +) / Double(results.count)
        let errors = results.compactMap { $0.error }
        let avgError = errors.reduce(0.0, +) / Double(results.count)
        
        print("{\"instance\": \"\(instanceId)\",\"initial_temperature\": \(initialTemperature ?? 512.0), \"average_time\": \(avgTime.rounded()), \"average_error\": \(avgError)}")
        
//        print("\nFinished\nAverage time: \(avgTime) ms\nMax time: \(times.max() ?? -1) ms\nAverage error: \(avgError)\nMax error: \(errors.max() ?? -1)")
    }
    
    func createEngine(from problemType: ProblemType) -> Engine {
        switch problemType {
        case .knapsack:
            return KnapsackEngine()
        case .mwsat:
            return MWSATEngine()
        }
    }
}

enum SimulatedAnnealingError: Error {
    case invalidProblemType
}
