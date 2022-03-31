//
//  Expression.swift
//  CountOnMe
//
//  Created by Rod on 25/03/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Expression {
    static let operators = "+-*/"

    static func elementIsAnOperator(_ element: Substring) -> Bool {
        return Self.operators.contains(element)
    }

    var rawString: String

//    var isEmpty: Bool {
//        self.rawString.trimmingCharacters(in: .whitespaces).isEmpty
//    }

    init(_ rawString: String = "") {
        self.rawString = rawString
    }

    var isEmpty: Bool { rawString.isEmpty }

    func clear() {
        rawString = ""
    }

    var elements: [Substring] {
        return rawString.split(separator: " ")
    }

    var lastElementIsAnOperator: Bool {
        guard let lastElement = elements.last else { return false }

        return Self.elementIsAnOperator(lastElement)
    }

    // Error check computed variables
    var isCorrect: Bool {
        return !lastElementIsAnOperator
    }

    var hasEnoughElements: Bool {
        return elements.count >= 3
    }

    var canAddOperator: Bool {
        return !lastElementIsAnOperator
    }

    func addDigit(_ digit: String) {
        rawString.append(digit)
    }

    func addOperator(_ ope: String) throws {
        guard !rawString.isEmpty else { throw ComputationError.operatorInFirstPosition }

        if lastElementIsAnOperator {
            rawString.removeLast(3)
        }
        rawString.append(" \(ope) ")
    }

    enum ComputationError: Error {
        case divisionByZero
        case badSyntax
        case operatorInFirstPosition
    }

    private static func calculate(_ left: Double, _ operatorSymbol: String, _ right: Double) throws -> Double {
        switch operatorSymbol {
        case "+": return left + right
        case "-": return left - right
        case "*": return left * right
        case "/":
            guard right != 0 else { throw ComputationError.divisionByZero }
            return left / right
        default: fatalError("Unknown operator !")
        }
    }

    private static func computePartialResult(for operatorSymbols: [String]? = nil, index: inout Int, operationsToReduce: inout [String]) throws {
        let operatorSymbol = operationsToReduce[index + 1]

        if operatorSymbols != nil {
            guard let operatorSymbols = operatorSymbols, operatorSymbols.contains(operatorSymbol) else {
                index += 2
                return
            }
        }

        let left = Double(operationsToReduce[index])!
        let right = Double(operationsToReduce[index + 2])!

        let result = try Self.calculate(left, operatorSymbol, right)

        operationsToReduce.removeSubrange(index + 1 ... index + 2)
        operationsToReduce[index] = "\(result)"
    }

    func getResult() throws -> String {
        // Create local copy of operations
        var operationsToReduce = elements.map(String.init)
        var index = 0

        // Iterate over operations while an operand still here
        while index <= operationsToReduce.count - 3 {
            try Self.computePartialResult(for: ["*", "/"], index: &index, operationsToReduce: &operationsToReduce)
//            print(index, operationsToReduce)
        }

        index = 0
        while operationsToReduce.count > 1 {
            try Self.computePartialResult(index: &index, operationsToReduce: &operationsToReduce)
//            print(index, operationsToReduce)
        }

        return operationsToReduce.first!
    }
}

class ExpressionComputation {
    enum Operator: String {
        case add = "+"
        case substract = "-"
        case multiply = "*"
        case divide = "/"
    }

    enum Element {
        case operation(Operator)
        case number(Double)

        var isOperation: Bool {
            if case .operation = self { return true }
            return false
        }
    }

    enum Err: Error {
        case divisionByZero
    }

    var elements: [Element] = []
    var result: Int?

    init(_ expression: Expression) {
        elements = expression.rawString
            .split(separator: " ")
            .enumerated()
            .map { n, elementString in
                let numberIsExpected = (n % 2 == 0)
                if numberIsExpected {
                    return .number(Double(elementString)!)
                } else {
                    return .operation(Operator(rawValue: String(elementString))!)
                }
            }
    }

    private static func calculate(_ left: Double, _ ope: Operator, _ right: Double) throws -> Double {
        switch ope {
        case .add: return left + right
        case .substract: return left - right
        case .multiply: return left * right
        case .divide:
            guard right != 0 else { throw Err.divisionByZero }
            return left / right
        }
    }

    private static func computePartialResult(for operators: [Operator]? = nil, index: inout Int, operationsToReduce: inout [Element]) throws -> Double! {
        guard case let Element.operation(ope) = operationsToReduce[index + 1]
        else { fatalError("Unknown operator : \(operationsToReduce[index + 1])") }

        if operators != nil {
            guard let operators = operators, operators.contains(ope) else {
                index += 2
                return nil
            }
        }

        guard case let Element.number(left) = operationsToReduce[index + 0],
              case let Element.number(right) = operationsToReduce[index + 2]
        else { fatalError("Unknown operation : \(operationsToReduce[index + 0 ... index + 2])") }

        let result = try Self.calculate(left, ope, right)

        operationsToReduce.removeSubrange(index + 1 ... index + 2)
        operationsToReduce[index] = .number(result)

        return result
    }

    func getResult() throws -> Double {
        var operationsToReduce = elements
        var index = 0
        var result: Double!

        // Iterate over operations while an operator still here
        while index <= operationsToReduce.count - 3 {
            result = try Self.computePartialResult(for: [.multiply, .divide], index: &index, operationsToReduce: &operationsToReduce)
//            print(index, operationsToReduce)
        }

        index = 0
        while operationsToReduce.count > 1 {
            result = try Self.computePartialResult(index: &index, operationsToReduce: &operationsToReduce)
//            print(index, operationsToReduce)
        }

        return result!
    }

    func clear() {
        elements = []
        result = nil
    }

    func addOperator(_ ope: Operator) {
        elements.append(.operation(ope))
    }

    func addNumber(_ value: Double) {
        elements.append(.number(value))
    }

    var lastElementIsAnOperator: Bool {
        elements.last.map { $0.isOperation } ?? false
    }

    // Error check computed variables
    var isCorrect: Bool {
        return !lastElementIsAnOperator
    }

    var hasEnoughElement: Bool {
        return elements.count >= 3
    }

    var canAddOperator: Bool {
        return !lastElementIsAnOperator
    }

    var hasResult: Bool {
        return result != nil
    }
}

enum ExpressionFormatter {
    private static var resultformatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private static func reformatOperator(c: Character) -> Character {
        return c == "*" ? "x" : c
    }

    static func format(_ expression: Expression) -> String {
        return expression.rawString.replacingOccurrences(of: "*", with: "x")
    }

    static func formatResult(_ result: String) -> String {
        let number = NSNumber(value: Double(result)!)
        return Self.resultformatter.string(from: number)!
    }

    static func formatResult(_ result: Double) -> String {
        let number = NSNumber(value: result)
        return Self.resultformatter.string(from: number)!
    }

    static func formatWithResult(_ expression: Expression) throws -> (String, Expression.ComputationError?) {
        var resultError: Expression.ComputationError?
        let result: String
        do {
            result = try expression.getResult()
        } catch {
            guard let err = error as? Expression.ComputationError else {
                throw error
            }
            result = "Err"
            resultError = err
        }
        let ending = "= \(Self.formatResult(result))"
        return (Self.format(expression) + ending, resultError)
    }
}
