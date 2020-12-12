//
//  Engine.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 12.12.2020.
//

import Foundation

protocol Engine {
    func loadProblems(_ path: String, _ count: Int) throws
    func measure(plot: Bool) -> [SolverResult]
}
