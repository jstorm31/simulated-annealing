//
//  KnapsackProblem.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

final class KnapsackProblem: Problem {
    struct Item: Encodable {
        let weight: Int
        let price: Int
    }
    
    var id: Int
    var capacity: Int
    var items: [KnapsackProblem.Item]
    var minPrice: Int
    
    init(id: Int, M: Int, items: [KnapsackProblem.Item]) {
        self.id = id
        self.capacity = M
        self.items = items
        self.minPrice = items.min { $0.price < $1.price }!.price
    }
    
    var size: Int {
        return items.count
    }
    
    var description: String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
    
    static func loadProblems(path: String, count: Int = 10) throws -> [KnapsackProblem] {
        let fullPath = NSString(string: path).expandingTildeInPath
        let text = try String(contentsOfFile: fullPath, encoding: .utf8)
        let lines = text.components(separatedBy: .newlines)[..<count]
        
        // Map the lines of the input file to KnapsackProblem object
        return lines.compactMap { line in
            guard !line.isEmpty else { return nil }
            
            let parts = line.components(separatedBy: .whitespaces)
            var items = [KnapsackProblem.Item]()
            
            // Map a problem items to KnapsackProblem.Item object (from index 4)
            for i in stride(from: 3, to: parts.count, by: 2) {
                items.append(.init(weight: Int(parts[i])!, price: Int(parts[i + 1])!))
            }
            
            return KnapsackProblem(id: Int(parts[0])!, M: Int(parts[2])!, items: items)
        }
    }
}
