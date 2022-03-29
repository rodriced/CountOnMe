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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        expression.rawString = "0"
        textView.text = expression.rawString
        hasResult = true
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
        processTappedOperator("*", displayedAs: "x")
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
            expression.clear()
            textView.text = expression.rawString
            hasResult = false
        }
        
        expression.addDigit(digit)
        textView.text.append(digit)
    }
    
    func processTappedOperator(_ operatorSymbol: String, displayedAs: String? = nil) {
        if expression.canAddOperator {
            expression.addOperator(operatorSymbol)
            
            textView.text.append(" \(displayedAs ?? operatorSymbol) ")
        } else {
            presentAlertVC("Un operateur est déja mis !")
        }
    }
    
    func displayResult() {
        do {
            let result = try expression.getResult()
            textView.text.append(" = \(result)")
            hasResult = true
        } catch {
            textView.text.append(" = Err")
        }
    }
    
    private func presentAlertVC(_ message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
