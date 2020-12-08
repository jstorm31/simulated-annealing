//
//  Problem.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

protocol Problem: Encodable, CustomStringConvertible {
    static func loadProblems(path: String, count: Int) throws -> [Self]
}

