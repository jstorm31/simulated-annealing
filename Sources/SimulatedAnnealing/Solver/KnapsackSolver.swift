//
//  KnapsackSolver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

final class KnapsackSolver: Solver {    
    typealias FrequencyStatistics = (better: Double, worse: Double)

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
    
    /// Find the initial temperature by increasing it and observing accepted changes to worse
    func temperatureTunning(_ ratioTreshold: Double = 0.8, _ epsilon: Double = 0.05, _ step: Temperature = 20.0) {
        var temperature = initialTemperature
        var state = initialState
        let acceptedInterval = (ratioTreshold - epsilon)...(ratioTreshold + epsilon)
        var frequency: FrequencyStatistics = (better: 1.0, worse: 1.0)
        let statisticsTreshold = 10
        var i = 0
        
        // First 10 iterations are for gathering some statistics
        while i <= statisticsTreshold || (i > statisticsTreshold && !acceptedInterval.contains(frequency.better / frequency.worse)) {
            if i > 50 {
                break // Do not spend much time finding the right temperature
            }
            
            let newState = next(state, temperature)
            
            if isBetter(newState, state) {
                frequency.better += 1.0
            } else {
                frequency.worse += 1.0
            }
            
            state = newState
            if i > statisticsTreshold {
                temperature += step
            }
            i += 1
        }
        
        initialTemperature = temperature
    }
    
    /// Calculate the error from reference solution
    func measureError(_ problem: KnapsackProblem, _ solution: KnapsackConfiguration) -> Double {
        let referenceSolution = WeightDecompositionSolver().solve(problem: problem)
        return calculateError(solution, referenceSolution)
    }
}
