//
//  Expression.swift
//  CountOnMe
//
//  Created by Rod on 25/03/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

class Expression {
    static let operators = "+-*/"

    
    var rawString: String
    
    init(_ rawString: String = "") {
        self.rawString = rawString
    }
    
    func clear() {
        rawString = ""
    }
        
    var elements: [Substring] {
        return rawString.split(separator: " ")
    }
    
    var lastElementIsAnOperator: Bool {
        guard let lastElement = elements.last else { return false }
        
        return Self.operators.contains(lastElement)
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
    
    func addOperator(_ ope: String) {
        rawString.append(" \(ope) ")
    }
   
    enum ComputationError: Error {
        case divisionByZero
        case badSyntax
    }
       
    private static func calculate(_ left: Int, _ operatorSymbol: String, _ right: Int) throws -> Int {
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

        let left = Int(operationsToReduce[index])!
        let right = Int(operationsToReduce[index + 2])!
        
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
