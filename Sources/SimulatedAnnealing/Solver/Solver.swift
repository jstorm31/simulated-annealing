//
//  Solver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

protocol Solver {
    typealias Temperature = Double
    
    var initialTemperature: Temperature { get }
    var coolingCoefficient: Double { get set }
    
    func frozen(_ temperature: Temperature) -> Bool
    func equilibrium(_ iteration: Int, _ problem: Problem) -> Bool
}

extension Solver {
    /// Solves the given problem using simulated annealing
    func solve(problem: Problem, initialState: Configuration) -> Configuration {
        var temperature = temperatureTunning(initialState)
        var best = initialState
        var state = initialState
        print("Initial state: \(initialState)\nInitial temperature: \(temperature)")
        
        while !frozen(temperature) {
            var i = 0
            
            while !equilibrium(i, problem) {
                i += 1
                state = next(best, temperature)
                
                if state.isBetter(than: best) {
                    best = state
                }
            }
            
            temperature *= coolingCoefficient
        }
        
        return best
    }
    
    /// Find the initial temperature by increasing it and observing accepted changes to worse
    private func temperatureTunning(_ initialState: Configuration, _ ratioTreshold: Double = 0.5, _ epsilon: Double = 0.05, _ step: Temperature = 50.0) -> Temperature {
        var temperature = initialTemperature
        var state = initialState
        var frequency = (better: 1.0, worse: 1.0)
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
        
        return temperature
    }
    
    /// Generates a neighbor configuration for the given one
    private func next(_ state: Configuration, _ temperature: Temperature) -> Configuration {
        let new = state.randomNeighbour
        
        if (new.isBetter(than: state)) {
            return new
        }
        
        let delta = Double(new.cost - state.cost)
        return Double.random(in: 0.0...1.0) < pow(M_E, -(delta / temperature)) ? new : state
    }
}
