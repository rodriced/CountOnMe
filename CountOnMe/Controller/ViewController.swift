//
//  ViewController.swift
//  CountOnMe
//
//  Created by Rod on 26/03/2022.
//

import UIKit

class ViewController: UIViewController {
    private var expression = Expression()

    @IBOutlet var textView: UITextView!
    
    private var hasResult: Bool = false
    
    // View Life cycles
    private func clear() {
        expression.clear()
        hasResult = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        clear()
        updateTextView()

    }
    
    @IBAction func tappedClearButton(_ sender: UIButton) {
        clear()
        updateTextView()

    }
    
    @IBAction private func tappedDigitButton(_ sender: UIButton) {
        guard let digit = sender.title(for: .normal) else {
            return
        }
        
        processTappedDigit(digit)
    }
    
    @IBAction private func tappedAddButton(_: UIButton) {
        processTappedOperator("+")
    }
    
    @IBAction private func tappedSubstractButton(_: UIButton) {
        processTappedOperator("-")
    }
    
    @IBAction private func tappedMultiplyButton(_ sender: UIButton) {
        processTappedOperator("*")
    }
    
    @IBAction private func tappedDivideButton(_ sender: UIButton) {
        processTappedOperator("/")
    }
    
    @IBAction private func tappedEqualButton(_ sender: UIButton) {
        guard expression.isCorrect else {
            presentAlertVC("Entrez une expression correcte !")
            return
        }
        
        guard expression.hasEnoughElements else {
            presentAlertVC("Démarrez un nouveau calcul !")
            return
        }
        
        displayResult()
    }
    
    // View actions
    func processTappedDigit(_ digit: String) {
        if hasResult {
            clear()
        }
        
        expression.addDigit(digit)

        updateTextView()
    }
    
    func processTappedOperator(_ operatorSymbol: String) {
        do {
            try expression.addOperator(operatorSymbol)
        
            updateTextView()
        } catch {
            presentAlertVC("Un opérateur ne peut pas être mis en premier !")
        }
    }
    
    func updateTextView(append extra: String? = nil) {
        let expr = expression.isEmpty ? "0" : ExpressionFormatter.format(expression)
        textView.text = expr + (extra ?? "")
    }
    
    func displayResult() {
        do {
            let result = try ExpressionComputation(expression).getResult()
//            let result = try expression.getResult()
            updateTextView(append: " = \(ExpressionFormatter.formatResult(result))")
            hasResult = true
        } catch {
            updateTextView(append: " = Err")
            hasResult = true
            presentAlertVC("Erreur : division par zéro !")
        }
    }
    
    private func presentAlertVC(_ message: String) {
        let alertVC = UIAlertController(title: "Zéro !", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
