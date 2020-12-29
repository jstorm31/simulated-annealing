//
//  MWSATSolver.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 26.12.2020.
//

import Foundation

struct MWSATSolver: Solver {
    var initialTemperature: Double
    var initialState: Configuration
    var coolingCoefficient: Double
    var equilibriumCoefficient: Int
    
    func frozen(_ temperature: Temperature, _ changeRatio: Float) -> Bool {
//        return changeRatio < 0.2
        return temperature <= 1.0
    }
    
    func equilibrium(_ iteration: Int, _ problem: Problem) -> Bool {
        return iteration >= (equilibriumCoefficient * problem.size)
    }
    
    func isBetter(_ lhs: Configuration, _ rhs: Configuration) -> Bool {
        let lhsSat = lhs as! MWSATConfiguration
        let rhsSat = rhs as! MWSATConfiguration
        
        if lhsSat.satisfiableClausesCount == rhsSat.satisfiableClausesCount {
            return lhsSat.weight > rhsSat.weight
        }
        return  lhsSat.satisfiableClausesCount > rhsSat.satisfiableClausesCount
    }
    
    func delta(_ current: Configuration, _ new: Configuration) -> Double {
        if current.cost == new.cost {
            return Double((new as! MWSATConfiguration).weight - (current as! MWSATConfiguration).weight)
        }
        return Double(new.cost - current.cost)
    }
    
    func measureError(_ solution: Configuration, _ referenceSolution: Configuration) -> Double {
        return calculateError(solution, referenceSolution)
    }
}
