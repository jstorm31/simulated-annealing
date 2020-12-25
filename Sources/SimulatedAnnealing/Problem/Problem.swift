//
//  Problem.swift
//  SimulatedAnnealing
//
//  Created by Jiří Zdvomka on 08.12.2020.
//

import Foundation

protocol Problem: Encodable, CustomStringConvertible {
    var size: Int { get }
}

extension Problem {
    var json: String {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}
