//
//  WelcomeViewController.swift
//  Math Buster
//
//  Created by Damir Chalkarov on 22.10.2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserScore()
    }
    
    func getUserScore() {
        let userDefaults = UserDefaults.standard
        
        guard let userScore = userDefaults.array(forKey: ViewController.userScoreKey) else {
            print("Userdefaults doesn't contain array with key: \(ViewController.userScoreKey)")
            return
        }
        
        guard let userScoreArrayOfDictionaries = userScore as? [[String: Any]] else {
            print("Couldn't convert Any to [[String: Any]]")
            return
        }
        
        print("userScoreArrayOfDictionaries: \(userScoreArrayOfDictionaries)")
        
        var text: String = ""
        
        userScoreArrayOfDictionaries.forEach { dictionary in
            if let name = dictionary["name"] as? String, let score = dictionary["score"] as? Int {
                text += "Name: \(name), Score: \(score) \n"
            }
        }
        
        textLabel.text = text
    }
    
   
 

}
