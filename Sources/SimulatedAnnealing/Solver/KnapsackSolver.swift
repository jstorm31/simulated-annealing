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
    
    private var frequency: FrequencyStatistics
        
    init(initialState: Configuration, initialTemperature: Double, coolingCoefficient: Double, equilibriumCoefficient: Int) {
        frequency = (better: 1.0, worse: 1.0)
        self.initialState = initialState
        self.coolingCoefficient = coolingCoefficient
        self.equilibriumCoefficient = equilibriumCoefficient
        self.initialTemperature = initialTemperature
    }
    
    func frozen(_ temperature: Double) -> Bool {
        return temperature < 1.0
    }
    
    func equilibrium(_ iteration: Int, _ problem: Problem) -> Bool {
        return iteration >= (equilibriumCoefficient * problem.size)
    }
    
    func gatherStatistics(_ newState: Configuration, _ oldState: Configuration) {
        if newState.isBetter(than: oldState) {
            frequency.better += 1.0
        } else {
            frequency.worse += 1.0
        }
    }
    
    /// Find the initial temperature by increasing it and observing accepted changes to worse
    func temperatureTunning(_ ratioTreshold: Double = 0.5, _ epsilon: Double = 0.05, _ step: Temperature = 50.0) {
        var temperature = initialTemperature
        var state = initialState
        let acceptedInterval = (ratioTreshold - epsilon)...(ratioTreshold + epsilon)
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
            } else {
                i += 1
            }
        }
        
        frequency = (better: 1.0, worse: 1.0)
        initialTemperature = temperature
    }
}
