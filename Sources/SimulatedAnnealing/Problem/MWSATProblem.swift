//
//  MW3SATProblem.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 25.12.2020.
//

import Foundation

final class MWSATProblem: Problem {
    let id: String
    let variableCount: Int
    let clauseCount: Int
    let weights: [Int]
    let formula: [[Int]]
    
    var size: Int {
        return variableCount
    }
    
    var description: String {
        return json
    }
    
    init(id: String, variableCount: Int, clauseCount: Int, weights: [Int], formula: [[Int]]) {
        self.id = id
        self.variableCount = variableCount
        self.clauseCount = clauseCount
        self.weights = weights
        self.formula = formula
    }
    
    static func loadProblem(path: String) throws -> MWSATProblem {
        let fullPath = NSString(string: path).expandingTildeInPath
        let text = try String(contentsOfFile: fullPath, encoding: .utf8)
        let lines = text.components(separatedBy: .newlines).filter { !$0.isEmpty }
        
        let idComponents = path.split(separator: "/")
        let id = String(idComponents[idComponents.count - 2] + "/" + idComponents[idComponents.count - 1])
        
        var variableCount: Int?
        var clauseCount: Int?
        var weights = [Int]()
        var formula = [[Int]]()
        var i: Int?
        
        for line in lines {
            let firstChar = line[line.startIndex]
            guard firstChar != "c" else {
                continue
            }
            
            if let clauseCount = clauseCount, let i = i, i >= clauseCount {
                break
            }
            
            if firstChar == "p" {
                // Instance info
                let components = Array(line.components(separatedBy: .whitespaces)[2...])
                variableCount = Int(components[0])
                clauseCount = Int(components[1])
            } else if firstChar == "w" {
                // Weight
                let components = line.components(separatedBy: .whitespaces).filter({ !$0.isEmpty })[1...variableCount!]
                weights = components.map { Int($0)! }
            } else {
                if i == nil {
                    i = 0
                }
                
                // 3SAT formula
                let components = line.components(separatedBy: .whitespaces).filter({ $0 != "" })[0..<3]
                formula.append(components.map { Int($0)! })
            }
        }
        
        return .init(id: id, variableCount: variableCount!, clauseCount: clauseCount!, weights: weights, formula: formula)
    }
    
    static func loadSolution(_ path: String, _ problem: MWSATProblem) throws -> MWSATConfiguration {
        let fullPath = NSString(string: path).expandingTildeInPath
        let problemId = problem.id.split(separator: "/").last!.split(separator: ".").first!
        var solution: MWSATConfiguration!
        
        if freopen(fullPath, "r", stdin) == nil {
            throw "Couldn't load the file from path \(fullPath)"
        }
        print(problemId)
        
        while let line = readLine() {
            let lineId = line.components(separatedBy: .whitespaces).first!
            guard "w" + lineId == problemId else {
                continue
            }
            
            let components = line.components(separatedBy: .whitespaces)
            let evaluation = Array(components[2..<problem.variableCount + 2].map { Int($0)! > 0 })
            solution = MWSATConfiguration(problem: problem, evaluation: evaluation)
        }
        
        return solution
    }
}


extension String: Error {}
