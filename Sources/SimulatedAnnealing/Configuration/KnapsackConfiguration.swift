//
//  Solution.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

struct KnapsackConfiguration: Configuration {
    var weight: Int?
    var price: Int
    var items: [Bool]
    
    var description: String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
    
    
    var cost: Int {
        
    }
    
    func randomNeighbour(for problem: KnapsackProblem) -> Configuration {
        let flipPosition = Int.random(in: 0...(items.count - 1))
        var newItems = items
        newItems[flipPosition] = !newItems[flipPosition]
        
        let (weight, price) = newItems.enumerated().reduce((0, 0)) { (acc, item) in
            let (i, isPresent) = item
            return isPresent ? (acc.0 + problem.items[i].weight, acc.1 + problem.items[i].price) : acc
        }
        return KnapsackConfiguration(weight: weight, price: price, items: newItems)
    }
    
    func isBetter(than: Configuration) -> Bool {
        <#code#>
    }
    
    static func loadSolutions(path: String, count: Int = 10) throws -> [Configuration] {
        let fullPath = NSString(string: path).expandingTildeInPath
        let text = try String(contentsOfFile: fullPath, encoding: .utf8)
        let lines = text.components(separatedBy: .newlines)[..<count]
        
        return lines.compactMap { line in
            guard !line.isEmpty else { return nil }
            
            let parts = line.components(separatedBy: .whitespaces)
            var items = [Bool]()
            
            for i in 3..<parts.count {
                items.append(parts[i] == "1")
            }
            
            return KnapsackConfiguration(weight: nil, price: Int(parts[2])!, items: items)
        }
    }
}

extension KnapsackConfiguration: Equatable {
    static func == (lhs: KnapsackConfiguration, rhs: KnapsackConfiguration) -> Bool {
        if lhs.price != rhs.price {
            return false
        }
        
        for i in 0..<lhs.items.count {
            if lhs.items[i] != rhs.items[i] {
                return false
            }
        }
        
        return true
    }
}
