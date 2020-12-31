//
//  Solution.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

protocol Configuration: Encodable, CustomStringConvertible {
    var cost: Int { get }
    var randomNeighbour: Configuration { get }
    var isSolution: Bool { get }
}
