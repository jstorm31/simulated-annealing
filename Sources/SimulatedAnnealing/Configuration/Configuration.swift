//
//  Solution.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

protocol Configuration: Encodable, CustomStringConvertible {
    var cost: Int { get }
    
    func randomNeighbour(for: Problem) -> Configuration
    func isBetter(than: Configuration) -> Bool
    static func loadSolutions(path: String, count: Int) throws -> [Configuration]
}
