//
//  WeightDecompositionSolver.swift
//  knapsack
//
//  Created by Jiří Zdvomka on 18/10/2020.
//

import Foundation

final class WeightDecompositionSolver {
    func solve(problem: KnapsackProblem) -> KnapsackConfiguration {
        var table: [[Int?]] = Array(repeating: Array(repeating: nil, count: problem.capacity + 1), count: problem.items.count)
        var occupiedIndexes: Set = [0]
        
        // Initialize first item / column manually
        table[0][0] = 0
        if problem.items[0].weight <= problem.capacity {
            table[0][problem.items[0].weight] = problem.items[0].price
            occupiedIndexes.insert(problem.items[0].weight)
        }
        
        // Compute the table from the second item
        for i in 1..<problem.items.count {
            for w in occupiedIndexes {
                // Copy previous configuration
                table[i][w] = maxOrNew(current: table[i][w], new: table[i-1][w]!)
                
                // Add new item to the previous configuration
                let newWeight = w + problem.items[i].weight
                if newWeight <= problem.capacity {
                    table[i][newWeight] = maxOrNew(current: table[i][newWeight], new: table[i-1][w]! + problem.items[i].price)
                    occupiedIndexes.insert(newWeight)
                }
            }
        }
        
        // Find the best configuration
        var solution = KnapsackConfiguration(problem: problem, weight: 0, price: 0, items: [Bool](repeating: false, count: problem.items.count))
        let max = table.last!.enumerated().filter { $1 != nil }.max { $0.element! < $1.element! }!
        solution.weight = max.offset
        solution.price = max.element!
        
        // Backtrack the configuration
        var backtrackedWeight = solution.weight
        for i in stride(from: problem.items.count - 1, to: 0, by: -1) {
            if table[i-1][backtrackedWeight] != table[i][backtrackedWeight] {
                solution.items[i] = true
                backtrackedWeight -= (problem.items[i].weight < backtrackedWeight ? problem.items[i].weight : backtrackedWeight)
            }
        }
        solution.items[0] = table[0][backtrackedWeight] != 0 // First item on index 0
        
        return solution
    }
    
    private func maxOrNew(current: Int?, new: Int) -> Int {
        if let current = current {
            return max(current, new)
        }
        return new
    }
}
