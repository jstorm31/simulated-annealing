//
//  Solver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation
import SwiftPlot
import AGGRenderer

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
        print("Initial state: \(state)\nInitial temperature: \(temperature)")
        
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
                                
                if state.isBetter(than: best) {
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
        
        if (new.isBetter(than: state)) {
            return new
        }
        
        let delta = Double(state.cost - new.cost)
        return Double.random(in: 0.0...1.0) < pow(M_E, -(delta / temperature)) ? new : state
    }
    
    func plot(_ points: [Int]) {
        let renderer = AGGRenderer()
        var plot = LineGraph<Float, Float>()
        plot.addSeries(points.enumerated().map { Float($0.0) }, points.map { Float($0) }, label: "", color: .lightBlue)
        plot.plotTitle.title = "Simulated annealing for Knapsack problem"
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
}
