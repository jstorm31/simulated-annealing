//
//  KnapsackSolver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

struct KnapsackSolver: Solver {
//    typealias ProblemType = KnapsackProblem
//    typealias ConfigurationType = KnapsackConfiguration
    
    func solve(problem: KnapsackProblem) -> KnapsackConfiguration {
        return KnapsackConfiguration(weight: nil, price: 40, items: [])
    }
}
