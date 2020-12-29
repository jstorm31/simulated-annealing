//
//  Solver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation
import SwiftPlot
import AGGRenderer

typealias FrequencyStatistics = (better: Double, worse: Double)

struct SolverResult {
    var solution: Configuration
    var error: Double?
    var time: Double?
}

protocol Solver {
    typealias Temperature = Double
    
    var initialTemperature: Temperature { get set }
    var initialState: Configuration { get set }
    var coolingCoefficient: Double { get set }
    
    func frozen(_ temperature: Temperature, _ changeRatio: Float) -> Bool
    func equilibrium(_ iteration: Int, _ problem: Problem) -> Bool
    func isBetter(_ lhs: Configuration, _ rhs: Configuration) -> Bool
    func delta(_ currentState: Configuration, _ newState: Configuration) -> Double
}

extension Solver {
    typealias PlotPoint = (x: Float, y: Float)
    
    /// Solves the given problem using simulated annealing
    func solve(_ problem: Problem, plot: Bool = false) -> Configuration {
        var temperature = initialTemperature
        var best = initialState
        var state = initialState
        var points = [Int]()
        
        var changes = 1
        var changeRatio: Float = 1.0
        var j = 0
//        print("Initial state: \(state)\nInitial temperature: \(temperature)")
        
        while !frozen(temperature, changeRatio) {
            var i = 0
                        
            while !equilibrium(i, problem) {
                if plot {
                    points.append(state.cost)
                }
                
                let newState = next(best, temperature)
                if newState.cost != state.cost {
                    changes += 1
                }
                state = newState
                                
                if isBetter(state, best) {
                    best = state
                }
                i += 1
            }
            
            changeRatio = Float(changes) / Float(j*i+1)
            temperature *= coolingCoefficient
            j += 1
        }
        
        if plot {
            self.plot(points)
        }
        return best
    }
    
    /// Generates a neighbor configuration for the given one
    func next(_ state: Configuration, _ temperature: Temperature) -> Configuration {
        let new = state.randomNeighbour
        
        if isBetter(new, state) {
            return new
        }
        
        let d = delta(state, new)
        let p = pow(M_E, -(d / temperature))
        return Double.random(in: 0.0...1.0) < p ? new : state
    }
    
    func plot(_ points: [Int]) {
        let renderer = AGGRenderer()
        var plot = LineGraph<Float, Float>()
        plot.addSeries(points.enumerated().map { Float($0.0) }, points.map { Float($0) }, label: "", color: .lightBlue)
        plot.plotTitle.title = "Simulated annealing for Weighted 3-SAT problem"
        plot.plotLabel.xLabel = "Iteration"
        plot.plotLabel.yLabel = "Cost"
        plot.plotLineThickness = 0.5
        
        let path = NSString(string: "~/FIT/KOP/simulated-annealing/Output").expandingTildeInPath
        let fileName = path + "/simulated_annealing"
        
        do {
            try plot.drawGraphAndOutput(fileName: fileName, renderer: renderer)
        } catch {
            print("Error generating plot")
            print(error)
        }
    }
    
    func calculateError(_ solution: Configuration, _ reference: Configuration) -> Double {
        return Double(abs(solution.cost - reference.cost)) / Double(max(solution.cost, reference.cost))
    }
    
    /// Find the initial temperature by increasing it and observing accepted changes to worse
    func temperatureTunning(_ ratioTreshold: Double = 1.0, _ epsilon: Double = 0.05, _ step: Temperature = 20.0) -> Temperature {
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
        
        return temperature
    }
}
