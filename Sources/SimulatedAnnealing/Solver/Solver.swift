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
        var temperature = initialTemperature
        var best = initialState
        var state = initialState
        print("Initial state: \(initialState)")
        
        while(!frozen(temperature)) {
            var i = 0
            
            while(!equilibrium(i, problem)) {
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
