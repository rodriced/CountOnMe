//
//  CountOnMeUITests.swift
//  CountOnMeUITests
//
//  Created by Rodolphe Desruelles on 26/03/2022.
//

@testable import CountOnMe
import XCTest

class CountOnMeUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func isDisplayedOperator(_ symbol: Character) -> Bool {
        "+-x/".contains(symbol)
    }

    func testMainUI() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Helpers //
        let tapButton: (Character) -> Void = {
            app.buttons[String($0)].tap()
        }

        var textViewValue: String {
            app.textViews["mainTextView"].value as! String
        }
        // ---------//

        // Testing display result with all digit and operators buttons
        let buttonsToTap = "12+34-56x78/90"
        var expectedDisplayedString = ""

        for symbol in buttonsToTap {
            tapButton(symbol)

            let buttonDisplayedResult = isDisplayedOperator(symbol) ? " \(symbol) " : "\(symbol)"
            expectedDisplayedString += buttonDisplayedResult

            XCTAssertEqual(textViewValue, expectedDisplayedString)
        }

        // Testing Equal button and computation result
        tapButton("=")
        XCTAssertEqual(textViewValue, expectedDisplayedString + " = -2,53")

        // Testing restarting new expression after previous result
        tapButton("1")
        tapButton("+")
        tapButton("=")
        XCTAssertTrue(app.alerts["errorAlert"].waitForExistence(timeout: 1))
        XCTAssertEqual(textViewValue, "1 + ")

        // Operator after result
        tapButton("1")
        tapButton("=")
        tapButton("+")
        XCTAssertTrue(app.alerts["errorAlert"].waitForExistence(timeout: 1))

        // Testing Clear button
        tapButton("1")
        tapButton("+")
        tapButton("C")
        XCTAssertEqual(textViewValue, "0")

        // Division by zero
        tapButton("7")
        tapButton("/")
        tapButton("0")
        tapButton("=")
        XCTAssertEqual(textViewValue, "7 / 0 = Err")
        XCTAssertTrue(app.alerts["errorAlert"].waitForExistence(timeout: 1))
    }
}
