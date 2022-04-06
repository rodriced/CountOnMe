//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Rodolphe Desruelles on 26/03/2022.
//

@testable import CountOnMe
import XCTest

class CountOnMeTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
   
    func testGivenUnknownOperator_WhenTestingItsExistence_ThenResultIsFalse() {
        XCTAssertEqual(ExpressionString.elementIsAnOperator("x"), false)
        XCTAssertEqual(ExpressionString.elementIsAnOperator("$"), false)
    }
    
    func testGivenKnownOperator_WhenTestingItsExistence_ThenResultIsTrue() {
        XCTAssertEqual(ExpressionString.elementIsAnOperator("+"), true)
        XCTAssertEqual(ExpressionString.elementIsAnOperator("*"), true)
    }
    
    func testGivenAnExpression_WhenClearingIt_ThenItContainsZero() {
        let expr = ExpressionString("3 - 6")
        expr.clear()
        XCTAssertEqual(expr.raw, "0")
    }

    func testGivenAnExpression_WhenGettingElements_ThenSeparationIsCorrect() {
        let expr = ExpressionString("3 + 6 / 8")
        XCTAssertEqual(expr.elements, ["3", "+", "6", "/", "8"])
    }
    
    func testGivenAnExpressionEndingWithAnOperator_WhenTestingIfLastElementIsAnOperator_ThenResultIsTrue() {
        XCTAssertEqual(ExpressionString("3 - 6 +").lastElementIsAnOperator, true)
        XCTAssertEqual(ExpressionString("3 - 6 + ").lastElementIsAnOperator, true)
    }
    
    func testGivenAnExpressionEndingWithANumber_WhenTestingIfLastElementIsAnOperator_ThenResultIsFalse() {
        XCTAssertEqual(ExpressionString("3 - 6 + 90").lastElementIsAnOperator, false)
    }

    func testGivenAnExpressionCorrectlyFormattedAndEndingWithANumber_WhenTestingItsCorectness_ThenResultIsTrue() {
        XCTAssertEqual(ExpressionString("3 + 23 * 8").isCorrect, true)
    }

    func testGivenAnExpressionIncorrectlyFormattedOrEndingWithAnOperator_WhenTestingItsCorectness_ThenResultIsFalse() {
        XCTAssertEqual(ExpressionString("34 + 2 *").isCorrect, false)
    }
    
    func testGivenANewExpression_WhenAddingZero_ThenNewNumberIsZero() {
        let expr = ExpressionString()
        expr.addDigit("0")
        XCTAssertEqual(expr.raw, "0")
    }
    
    func testGivenANewExpression_WhenAddingDigits_ThenNewNumberIsBuiltCorrectly() {
        let expr = ExpressionString()
        expr.addDigit("3")
        XCTAssertEqual(expr.raw, "3")
        expr.addDigit("0")
        XCTAssertEqual(expr.raw, "30")
    }
    
    func testGivenAnExpressionEndingWithAnOperator_WhenAddingZero_ThenZeroIsAddedCorrectly() {
        let expr = ExpressionString("30 + 6 / ")
        expr.addDigit("0")
        XCTAssertEqual(expr.raw, "30 + 6 / 0")
    }
    
    func testGivenAnExpressionEndingWithAnAloneZero_WhenAddingOtherDigits_ThenZeroIsRepcedByAddedDigits() {
        let expr = ExpressionString("30 + 6 / 0")
        expr.addDigit("8")
        XCTAssertEqual(expr.raw, "30 + 6 / 8")
        expr.addDigit("5")
        XCTAssertEqual(expr.raw, "30 + 6 / 85")
    }

    func testGivenANewExpression_WhenAddingAnOperator_ThenOperatorIsAddedAfterZero() {
        let expr = ExpressionString()
        expr.addOperator("+")
        XCTAssertEqual(expr.raw, "0 + ")
    }

    func testGivenAnExpressionEndingWithAnOperator_WhenAddingANewOperator_ThenOperatorIsReplacedByTheNewOne() {
        let expr = ExpressionString("3 + 6 / ")
        expr.addOperator("-")
        XCTAssertEqual(expr.raw, "3 + 6 - ")
    }
    
    func testGivenANewExpression_WhenExpressionIsFormatted_ThenResultIsAStringWithZero() {
        let expr = ExpressionString()
        XCTAssertEqual(ExpressionFormatter.format(expr), "0")
        
    }
    
    func testGivenAnExpressionWithAMultiplyOperator_WhenExpressionIsFormatted_ThenMultiplyOperatorIsCorrectlyFormatted() {
        let expr = ExpressionString("3 * 6 / 8")
        XCTAssertEqual(ExpressionFormatter.format(expr), "3 x 6 / 8")
    }

    func testGivenADoubleNumber_WhenFormatting_ThenNumberIsCorrectlyFormatted() {
        XCTAssertEqual(ExpressionFormatter.formatResult(2), "2")
        XCTAssertEqual(ExpressionFormatter.formatResult(2.34), "2,34")
        XCTAssertEqual(ExpressionFormatter.formatResult(2.2485), "2,25")
    }

    // Helper for testing expression computation
    func resultTest(_ exprString: String, expected: String, comment: String = "") {
        let expr = ExpressionString(exprString)
        let result = try! ExpressionComputation(expr).getResult()
        let formattedResult = ExpressionFormatter.formatResult(result)
        XCTAssertEqual(formattedResult, expected, "\(ExpressionFormatter.format(expr)) = \(expected)" + (comment.isEmpty ? "" : ", " + comment))
    }
    
    // Helper for testing expression computation error
    func resultErrorTest(_ exprString: String) {
        let expr = ExpressionString(exprString)
        XCTAssertThrowsError(try ExpressionComputation(expr).getResult())
    }
    
    func testAnExpressionWithOnlyANumber_WhenComputingResult_ThenFormatedResultIsCorrect() {
        resultTest("0", expected: "0")
        resultTest("8", expected: "8")
        resultTest("235", expected: "235")
    }
    
    func testGivenASimpleExpression_WhenComputingResult_ThenFormatedResultIsCorrect() {
        resultTest("2 + 1", expected: "3")
        resultTest("10 - 2", expected: "8")
        resultTest("8 / 2", expected: "4")
        resultTest("6 * 3", expected: "18")
    }
    
    func testGivenAnExpressionWithANonIntegerDivision_WhenComputingResult_ThenResultIsFormattedWithAtMostTwoDecimalPlaces() {
        resultTest("7 / 2", expected: "3,5")
        resultTest("9 / 4", expected: "2,25")
        resultTest("10 / 3", expected: "3,33")
    }

    func testGivenAnExpressionContainingADivisionByZero_WhenComputingResult_ThenErrorIsThrown() {
        resultErrorTest("5 / 0")
        resultErrorTest("3 + 23 / 0 - 4")
    }

    func testGivenAnExpressionWithAMixOfPriorityAndNotPriorityOperations_WhenComputingResult_ThenOperatorsPrecedenceAndFormatedResultAreCorrect() {
        resultTest("3 * 2 + 7", expected: "13")
        resultTest("3 + 2 * 7", expected: "17")
        resultTest("3 + 2 * 7 + 5 * 4", expected: "37")
        resultTest("34 + 23 * 74 - 523 / 4", expected: "1605,25")
    }
}
