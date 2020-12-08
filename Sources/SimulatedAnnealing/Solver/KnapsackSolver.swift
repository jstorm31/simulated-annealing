//
//  KnapsackSolver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

final class KnapsackSolver: Solver {
    let initialTemperature: Double
    let initialState: Configuration
    let coolingCoefficient: Double
    let k: Int // Problem size coefficient
        
    init(initialTemperature: Double, initialState: KnapsackConfiguration, coolingCoefficient: Double, k: Int) {
        self.initialTemperature = initialTemperature
        self.initialState = initialState
        self.coolingCoefficient = coolingCoefficient
        self.k = k
    }
    
    func frozen(_ temperature: Double) -> Bool {
        <#code#>
    }
    
    func equilibrium(_ iteration: Int, _ problem: Problem) -> Bool {
        return iteration >= (k * problem.size)
    }
}
