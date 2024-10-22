//
//  ViewController.swift
//  Math Buster
//
//  Created by Damir Chalkarov on 16.10.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var timerContainerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var resultField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var timer: Timer?
    var countDown: Int = 30
    var result: Double?
    var score: Int = 0
    var navigationBarPreviousTintColor: UIColor?
    
    static let  userScoreKey = "userScore"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Math Buster"
        setupUI()
        generateProblem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBarPreviousTintColor = navigationController?.navigationBar.tintColor
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scheduleTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = navigationBarPreviousTintColor
    }
    
    func setupUI() {
        timerContainerView.layer.cornerRadius = 5
        resultField.keyboardType = .decimalPad
    }
    
    func generateProblem() {
        
        if score == 5 {
            segmentControl.selectedSegmentIndex = 1
        }
        if score >= 10 {
            segmentControl.selectedSegmentIndex = 2
        }
        
        if segmentControl.selectedSegmentIndex == 0 {
            let firstDigit = Int.random(in: 0...9)
            guard let arithmeticOperator = ["+", "-", "/", "*"].randomElement() else {return}
            var startingInteger: Int = 0
            var endingInteger: Int = 9
            if arithmeticOperator == "/" {
                startingInteger = 1
            } else if arithmeticOperator == "-" {
                endingInteger = firstDigit
            }
            let secondDigit = Int.random(in: startingInteger...endingInteger)
            
            problemLabel.text = "\(firstDigit) \(arithmeticOperator) \(secondDigit) ="
            
            switch arithmeticOperator {
                case "+":
                    result = Double(firstDigit + secondDigit)
                case "-":
                    result = Double(firstDigit - secondDigit)
                case "*":
                    result = Double(firstDigit * secondDigit)
                case "/":
                    result = Double(firstDigit) / Double(secondDigit)
                default:
                    result = nil
            }
        } else if segmentControl.selectedSegmentIndex == 1 {
            let firstDigit = Int.random(in: 10...99)
            guard let arithmeticOperator = ["+", "-", "/", "*"].randomElement() else {return}
            let startingInteger: Int = 10
            var endingInteger: Int = 99
            if arithmeticOperator == "-" {
                endingInteger = firstDigit
            }
            let secondDigit = Int.random(in: startingInteger...endingInteger)
            
            problemLabel.text = "\(firstDigit) \(arithmeticOperator) \(secondDigit) ="
            
            switch arithmeticOperator {
                case "+":
                    result = Double(firstDigit + secondDigit)
                case "-":
                    result = Double(firstDigit - secondDigit)
                case "*":
                    result = Double(firstDigit * secondDigit)
                case "/":
                    result = Double(firstDigit) / Double(secondDigit)
                default:
                    result = nil
            }
        } else if segmentControl.selectedSegmentIndex == 2 {
            let firstDigit = Int.random(in: 100...999)
            guard let arithmeticOperator = ["+", "-", "/", "*"].randomElement() else {return}
            let startingInteger: Int = 100
            var endingInteger: Int = 999
            if arithmeticOperator == "-" {
                endingInteger = firstDigit
            }
            let secondDigit = Int.random(in: startingInteger...endingInteger)
            
            problemLabel.text = "\(firstDigit) \(arithmeticOperator) \(secondDigit) ="
            
            switch arithmeticOperator {
                case "+":
                    result = Double(firstDigit + secondDigit)
                case "-":
                    result = Double(firstDigit - secondDigit)
                case "*":
                    result = Double(firstDigit * secondDigit)
                case "/":
                    result = Double(firstDigit) / Double(secondDigit)
                default:
                    result = nil
            }
        }
    }
    
    func scheduleTimer() {
        countDown = 3
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerUI), userInfo: nil, repeats: true)
    }
    
    @objc
    func updateTimerUI() {
        countDown -= 1
        
        timerLabel.text = "00 : \(countDown)"
        if countDown < 10 {
            timerLabel.text = "00 : 0\(countDown)"
        }
        progressView.progress = Float((30 - countDown)) / 30
        
        if countDown <= 0 {
            finishTheGame()
        }
    }

    @IBAction func submitPressed(_ sender: Any) {
        guard let text = resultField.text else {
            print("Text is nil")
            return
        }
        guard !text.isEmpty else {
            print("Text is empty")
            return
        }
        
        if segmentControl.selectedSegmentIndex == 0 {
            guard let result = Double(text) else {
                print("Couldn't convert text \(text) to Double")
                return
            }
            
            if result == self.result {
                print("Correct answer")
                score += 1
                scoreLabel.text = "Score \(score)"
            } else {
                print("Incorrect answer")
            }
        }
        
        if segmentControl.selectedSegmentIndex == 1 {
            guard let result = Double(text) else {
                print("Couldn't convert text \(text) to Double")
                return
            }
            
            if result == self.result {
                print("Correct answer")
                score += 2
                scoreLabel.text = "Score \(score)"
            } else {
                print("Incorrect answer")
            }
        }
        
        if segmentControl.selectedSegmentIndex == 2 {
            guard let result = Double(text) else {
                print("Couldn't convert text \(text) to Double")
                return
            }
            
            if result == self.result {
                print("Correct answer")
                score += 3
                scoreLabel.text = "Score \(score)"
            } else {
                print("Incorrect answer")
            }
        }
        
        generateProblem()
        resultField.text = nil
    }
    
    @IBAction func restartPressed(_ sender: Any) {
        score = 0
        scoreLabel.text = "Score 0"
        
        generateProblem()
        
        scheduleTimer()
        
        resultField.isEnabled = true
        submitButton.isEnabled = true
    }
    
    func finishTheGame() {
        timer?.invalidate()
        resultField.isEnabled = false
        submitButton.isEnabled = false
        
        askForName()
    }
    
    func askForName() {
        let alertController = UIAlertController(title: "Game is over", message: "Save your score: \(score)", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter your name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alertController.textFields?.first else {
                print("Textfield is absent")
                return
            }
            
            guard let text = textField.text, !text.isEmpty else {
                print("Text is nil or empty")
                return
            }
            
            print("Name: \(text)")
            
            //TO DO: Save your score record permanently on device
            
            self.saveUserScore(name: text)
        }
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
    
    func saveUserScore(name: String) {
        let userScore: [String: Any] = ["name": name, "score": score]
        let userScoreArray: [[String: Any]] = getUserScoreArray() + [userScore]
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(userScoreArray, forKey: ViewController.userScoreKey)
        
    }
    
    func getUserScoreArray() -> [[String: Any]] {
        let userDefaults = UserDefaults.standard
        let array = userDefaults.array(forKey: ViewController.userScoreKey) as? [[String: Any]]
        return array ?? []
        
    }
}

