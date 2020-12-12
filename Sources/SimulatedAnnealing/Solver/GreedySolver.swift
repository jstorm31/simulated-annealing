//
//  GreedySolver.swift
//  knapsackTests
//
//  Created by Jiří Zdvomka on 18/10/2020.
//

import Foundation

final class GreedySolver {
    func solve(_ problem: KnapsackProblem) -> KnapsackConfiguration {
        var solution = KnapsackConfiguration(problem: problem, weight: 0, price: 0, items: [])
        
        let items = problem.items.sorted { lhs, rhs in
            Double(lhs.price / lhs.weight) > Double(rhs.price / rhs.weight)
        }
        
        for item in items {
            if solution.weight + item.weight <= problem.capacity {
                solution.weight += item.weight
                solution.price += item.price
                solution.items.append(true)
            }
        }
        
        for _ in solution.items.count..<problem.items.count {
            solution.items.append(false)
        }
        
        return solution
    }
}
