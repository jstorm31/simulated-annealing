//
//  Solution.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

struct KnapsackConfiguration: Configuration {
    var problem: KnapsackProblem
    var weight: Int
    var price: Int
    var items: [Bool]
    
    var fitsCapacity: Bool {
        return weight <= problem.capacity
    }
    
    var isSolution: Bool {
        return fitsCapacity
    }
    
    var cost: Int {
        if !fitsCapacity {
            return Int.random(in: 0...(problem.minPrice - 1))
        }
        
        return price
    }
    
    var randomNeighbour: Configuration {
        let flipPosition = Int.random(in: 0...(items.count - 1))
        var newItems = items
        newItems[flipPosition] = !newItems[flipPosition]

        let sign = newItems[flipPosition] ? +1 : -1
        let newWeight = weight + sign * problem.items[flipPosition].weight
        let newPrice = price + sign * problem.items[flipPosition].price

        return KnapsackConfiguration(problem: problem, weight: newWeight, price: newPrice, items: newItems)
    }
    
    var description: String {
        return "{ price: \(price), weight: \(weight), items: \(items.map { $0 ? 1 : 0 } ) }"
    }
    
    static func randomSolution(for problem: KnapsackProblem) -> KnapsackConfiguration {
        var configuration = KnapsackConfiguration(problem: problem, weight: 0, price: 0, items: [])
        
        for item in problem.items {
            if Bool.random() {
                configuration.items.append(true)
                configuration.weight += item.weight
                configuration.price += item.price
            } else {
                configuration.items.append(false)
            }
        }
        
        return configuration
    }
}
