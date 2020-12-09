//
//  KnapsackSolver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

final class KnapsackSolver: Solver {
    let initialTemperature: Double
    var coolingCoefficient: Double
    let problemSizeCoefficient: Int
        
    init(initialTemperature: Double, coolingCoefficient: Double, problemSizeCoefficient: Int) {
        self.initialTemperature = initialTemperature
        self.coolingCoefficient = coolingCoefficient
        self.problemSizeCoefficient = problemSizeCoefficient
    }
    
    func frozen(_ temperature: Double) -> Bool {
        // TODO: Implement as a change ratio dropping under a treshold
        return temperature < 5.0
    }
    
    func equilibrium(_ iteration: Int, _ problem: Problem) -> Bool {
        return iteration >= (problemSizeCoefficient * problem.size)
    }
}
