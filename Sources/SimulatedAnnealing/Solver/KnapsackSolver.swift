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
    
    func frozen(_ temperature: Double) -> Bool {
        return temperature < 1.0
    }
    
    func equilibrium(_ iteration: Int, _ problem: Problem) -> Bool {
        return iteration >= (equilibriumCoefficient * problem.size)
    }
    
    /// Find the initial temperature by increasing it and observing accepted changes to worse
    func temperatureTunning(_ ratioTreshold: Double = 1.0, _ epsilon: Double = 0.05, _ step: Temperature = 50.0) {
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
            
            if newState.isBetter(than: state) {
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
    
    func calculateError(_ solution: KnapsackConfiguration, _ reference: KnapsackConfiguration) -> Double {
        return Double(abs(solution.price - reference.price)) / Double(max(solution.price, reference.price))
    }
}
