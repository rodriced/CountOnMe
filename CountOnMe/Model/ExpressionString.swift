//
//  Expression.swift
//  CountOnMe
//
//  Created by Rodolphe Desruelles on 25/03/2022.
//


class ExpressionString {
    private static let operators = "+-*/"

    static func elementIsAnOperator(_ element: Substring) -> Bool {
        return Self.operators.contains(element)
    }

    private(set) var raw: String

    init() {
        self.raw = "0"
    }
    
    // For testing
    init(_ rawString: String) {
        self.raw = rawString
    }
    
    func clear() {
        raw = "0"
    }

    var elements: [Substring] {
        return raw.split(separator: " ")
    }

    var lastElementIsAnOperator: Bool {
        guard let lastElement = elements.last else { return false }

        return Self.elementIsAnOperator(lastElement)
    }

    // Expression is correct when ending with a number
    var isCorrect: Bool {
        return !lastElementIsAnOperator
    }

    func addDigit(_ digit: String) {
        // A number can be 0 but cannot begin with 0 if it has more than one digit
        if raw == "0" { raw = digit; return }
        
        if raw.hasSuffix(" 0") {
            raw.removeLast()
        }
        
        raw.append(digit)
    }

    func addOperator(_ ope: String) {
        if lastElementIsAnOperator {
            raw.removeLast(3)
        }
        raw.append(" \(ope) ")
    }
}
