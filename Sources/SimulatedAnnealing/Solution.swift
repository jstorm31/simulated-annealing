//
//  Solution.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

struct Solution: Encodable, CustomStringConvertible {
    var weight: Int?
    var price: Int
    var items: [Bool]
    
    var description: String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
    
    static func loadSolutions(path: String, count: Int = 10) throws -> [Solution] {
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
            
            return Solution(weight: nil, price: Int(parts[2])!, items: items)
        }
    }
}

extension Solution: Equatable {
    static func == (lhs: Solution, rhs: Solution) -> Bool {
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
