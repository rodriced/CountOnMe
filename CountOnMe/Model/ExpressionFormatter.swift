//
//  ExpressionFormatter.swift
//  CountOnMe
//
//  Created by Rodolphe Desruelles on 25/03/2022.
//

import Foundation

class ExpressionFormatter {
    private static var resultFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        return formatter
    }()

    private static func reformatOperators(_ exprString: String) -> String {
        exprString.replacingOccurrences(of: "*", with: "x")
    }

    static func format(_ expression: ExpressionString) -> String {
        reformatOperators(expression.raw)
    }

    static func formatResult(_ result: Double) -> String {
        let number = NSNumber(value: result)
        return Self.resultFormatter.string(from: number)!
    }
}
