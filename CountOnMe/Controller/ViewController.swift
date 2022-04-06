//
//  ViewController.swift
//  CountOnMe
//
//  Created by Rodolphe Desruelles on 26/03/2022.
//

import UIKit

class ViewController: UIViewController {
    private var expression = ExpressionString()

    private var hasResult = false
    
    // View components //
    
    @IBOutlet private var textView: UITextView!
    
    // View events //
    
    @IBAction private func tappedClearButton(_: UIButton) {
        clear()
        updateTextView()
    }
    
    @IBAction private func tappedDigitButton(_ sender: UIButton) {
        guard let digit = sender.title(for: .normal) else {
            return
        }
        
        processDigit(digit)
    }
    
    @IBAction private func tappedAddButton(_: UIButton) {
        processOperator("+")
    }
    
    @IBAction private func tappedSubstractButton(_: UIButton) {
        processOperator("-")
    }
    
    @IBAction private func tappedMultiplyButton(_: UIButton) {
        processOperator("*")
    }
    
    @IBAction private func tappedDivideButton(_: UIButton) {
        processOperator("/")
    }
    
    @IBAction private func tappedEqualButton(_: UIButton) {
        processEqual()
    }
    
    // Logic //
    
    private func clear() {
        expression.clear()
        hasResult = false
    }
    
    private func processDigit(_ digit: String) {
        if hasResult {
            clear()
        }
        
        expression.addDigit(digit)

        updateTextView()
    }
    
    private func processOperator(_ operatorSymbol: String) {
        guard !hasResult else {
            presentAlertVC("Démarrez un nouveau calcul avec la touche C ou en tapant un chiffre !")
            return
        }

        expression.addOperator(operatorSymbol)
        
        updateTextView()
    }
    
    private func processEqual() {
        guard expression.isCorrect else {
            presentAlertVC("Entrez une expression correcte !")
            return
        }
        
        displayResult()
    }
    
    private func displayResult() {
        do {
            let number = try ExpressionComputation(expression).getResult()
            updateTextView(append: " = \(ExpressionFormatter.formatResult(number))")
            hasResult = true
        } catch {
            updateTextView(append: " = Err")
            hasResult = true
            presentAlertVC("Erreur : division par zéro !")
        }
    }
    
    private func updateTextView(append extra: String? = nil) {
        textView.text = ExpressionFormatter.format(expression) + (extra ?? "")
    }

    private func presentAlertVC(_ message: String) {
        let alertVC = UIAlertController(title: "Zéro !", message: message, preferredStyle: .alert)
        alertVC.view.accessibilityIdentifier = "errorAlert"
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    // Initialization //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        clear()
        updateTextView()
    }
}
