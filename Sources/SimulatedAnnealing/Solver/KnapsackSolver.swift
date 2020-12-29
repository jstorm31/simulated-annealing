//
//  KnapsackSolver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

final class KnapsackSolver: Solver {    
    var initialTemperature: Double
    var initialState: Configuration
    var coolingCoefficient: Double
    let equilibriumCoefficient: Int
        
    init(initialState: Configuration, initialTemperature: Double, coolingCoefficient: Double, equilibriumCoefficient: Int) {
        self.initialTemperature = initialTemperature
        self.initialState = initialState
        self.coolingCoefficient = coolingCoefficient
        self.equilibriumCoefficient = equilibriumCoefficient
    }
    
    func frozen(_ temperature: Double, _ changeRatio: Float) -> Bool {
        return changeRatio < 0.2
    }
    
    func equilibrium(_ iteration: Int, _ problem: Problem) -> Bool {
        return iteration >= (equilibriumCoefficient * problem.size)
    }
    
    func isBetter(_ lhs: Configuration, _ rhs: Configuration) -> Bool {
        return lhs.cost > rhs.cost
    }
    
    func delta(_ currentState: Configuration, _ newState: Configuration) -> Double {
        return Double(currentState.cost - newState.cost)
    }
    
    /// Calculate the error from reference solution
    func measureError(_ problem: KnapsackProblem, _ solution: KnapsackConfiguration) -> Double {
        let referenceSolution = WeightDecompositionSolver().solve(problem: problem)
        return calculateError(solution, referenceSolution)
    }
}
