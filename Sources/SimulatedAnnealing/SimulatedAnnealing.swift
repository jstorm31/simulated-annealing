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
        let problems = try KnapsackProblem.loadProblems(path: inputPath)
        print(problems)
    }
}
