//
//  Solver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

protocol Solver {
    associatedtype ProblemType
    associatedtype ConfigurationType
    
    func solve(problem: ProblemType) -> ConfigurationType
}
