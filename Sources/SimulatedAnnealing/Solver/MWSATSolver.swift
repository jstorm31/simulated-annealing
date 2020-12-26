//
//  MWSATSolver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 26.12.2020.
//

import Foundation

struct MWSATSolver: Solver {
    var initialTemperature: Double
    var initialState: Configuration
    var coolingCoefficient: Double
    var equilibriumCoefficient: Int
    
    func frozen(_ temperature: Temperature, _ changeRatio: Float) -> Bool {
        return changeRatio < 0.2
    }
    
    func equilibrium(_ iteration: Int, _ problem: Problem) -> Bool {
        return iteration >= (equilibriumCoefficient * problem.size)
    }
}
