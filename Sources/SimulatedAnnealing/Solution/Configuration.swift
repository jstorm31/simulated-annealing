//
//  Solution.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

protocol Configuration: Encodable, CustomStringConvertible {
    static func loadSolutions(path: String, count: Int) throws -> [Self]
}
