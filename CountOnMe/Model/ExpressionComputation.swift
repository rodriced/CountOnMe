//
//  Expression.swift
//  CountOnMe
//
//  Created by Rodolphe Desruelles on 25/03/2022.
//

class ExpressionComputation {
    enum Err: Error {
        case divisionByZero
    }

    private enum MathOperator: String {
        case add = "+"
        case substract = "-"
        case multiply = "*"
        case divide = "/"

        func calculateWith(left: Double, right: Double) throws -> Double {
            switch self {
            case .add: return left + right
            case .substract: return left - right
            case .multiply: return left * right
            case .divide:
                guard right != 0 else { throw Err.divisionByZero }
                return left / right
            }
        }
    }
    
    private struct Operation {
        var mathOperator: MathOperator
        var number: Double

        init(_ operatorSymbol: Substring, _ numberString: Substring) {
            self.mathOperator = MathOperator(rawValue: String(operatorSymbol))!
            self.number = Double(numberString)!
        }
    }

    private var firstNumber: Double
    private var operations: [Operation] = []

    init(_ expression: ExpressionString) {
        let elements = expression.elements

        firstNumber = Double(elements[0])!

        for index in stride(from: 1, to: elements.count, by: 2) {
            let operatorSymbol = elements[index]
            let numberString = elements[index + 1]
            operations.append(Operation(operatorSymbol, numberString))
        }
    }

    private func reduceOperations(onlyFor autohrizedOperators: [MathOperator]? = nil) throws {
        var i = 0
        while i < operations.count {
            let mathOperator = operations[i].mathOperator
            
            // Go to next operation if necessary (operators precedence usage)
            if let autohrizedOperators = autohrizedOperators, !autohrizedOperators.contains(mathOperator) {
                i += 1
                continue
            }

            // Reducing current operation
            if i == 0 {
                firstNumber = try mathOperator.calculateWith(left: firstNumber, right: operations[i].number)
            } else {
                operations[i - 1].number = try mathOperator.calculateWith(left: operations[i - 1].number, right: operations[i].number)
            }
            operations.remove(at: i)
        }
    }

    func getResult() throws -> Double {
        // Reduction in 2 passes for dealing with operators precedence
        try reduceOperations(onlyFor: [.multiply, .divide])
        try reduceOperations()

        return firstNumber
    }
}
