//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Rod on 26/03/2022.
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

    func expresionResultTest(_ expr: String, expected: String, comment: String = "") {
        let expr = Expression(expr)
        XCTAssertEqual(try! expr.getResult(), expected, "\(expr) = \(expected)" + (comment.isEmpty ? "" : ", " + comment))
    }
    
//    func testNew() {
//        ExpressionComputation(Expression("5 + 2"))
//    }
    
    func testIsEmpty() {
        XCTAssertEqual(Expression().isEmpty, true)
        XCTAssertEqual(Expression("3 + 2").isEmpty, false)
    }
    
    func testClear() {
        let expr = Expression("3 - 6")
        expr.clear()
        XCTAssertEqual(expr.isEmpty, true)
    }

    func testLastElementIsAnOperator() {
        XCTAssertEqual(Expression("3 - 6 +").lastElementIsAnOperator, true)
        XCTAssertEqual(Expression("3 - 6 + ").lastElementIsAnOperator, true)
        XCTAssertEqual(Expression("3 - 6 + 90").lastElementIsAnOperator, false)
    }

    func testSimpleExpression() {
        expresionResultTest("8", expected: "8")
        expresionResultTest("235", expected: "235")

        expresionResultTest("2 + 1", expected: "3")

        expresionResultTest("10 - 2", expected: "8")

        expresionResultTest("8 / 2", expected: "4")
        expresionResultTest("25 / 3", expected: "8")

        expresionResultTest("6 * 3", expected: "18")
        expresionResultTest("6 * 3 / 3", expected: "6")
    }

    func testExpressionWithZero() {
        expresionResultTest("0 + 0", expected: "0")
        expresionResultTest("2 + 0", expected: "2")

        expresionResultTest("0 - 2", expected: "-2")

        expresionResultTest("0 / 156", expected: "0")

        expresionResultTest("0 * 0", expected: "0")
        expresionResultTest("0 * 24", expected: "0")
        expresionResultTest("340 * 0", expected: "0")
    }

    func testErrorWhenDividingByZero() {
        XCTAssertThrowsError(try Expression("5 / 0").getResult())
        XCTAssertThrowsError(try Expression("3 + 23 / 0 - 4").getResult())
    }

    func testExpressionWithPrecedence() {
        expresionResultTest("3 * 2 + 7", expected: "13")
        expresionResultTest("3 + 2 * 7", expected: "17")
        expresionResultTest("3 + 2 * 7 + 5 * 4", expected: "37")
        expresionResultTest("34 + 23 * 74 - 523 / 4", expected: "1606")
    }

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
