
import UIKit

class WelcomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var multiplayerButton: UIBarButtonItem!
    
    var userScoreArrayOfDictionaries: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: ScoreTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        multiplayerButton.customView?.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserScore()
    }
    
    func getUserScore() {
        let userDefaults = UserDefaults.standard
        
        guard let userScore = userDefaults.array(forKey: ViewController.userScoreKey) else {
            print("UserDefaults doesn't contain array with key: \(ViewController.userScoreKey)")
            return
        }
        
        guard let userScoreArrayOfDictionaries = userScore as? [[String: Any]] else {
            print("Couldn't convert Any to [[String: Any]]")
            return
        }
        
        self.userScoreArrayOfDictionaries = userScoreArrayOfDictionaries
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userScoreArrayOfDictionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as! ScoreTableViewCell
        
        let dictionary: [String: Any] = userScoreArrayOfDictionaries[indexPath.row]
        if let name = dictionary["name"] as? String, let score = dictionary["score"] as? Int {
            cell.scoreTextLabel.text = "Name: \(name), Score: \(score)"
            
            if indexPath.row == 0 {
                cell.scoreTextLabel.font = UIFont.boldSystemFont(ofSize: 18) // Жирный текст
            } else {
                cell.scoreTextLabel.font = UIFont.systemFont(ofSize: 17) // Обычный шрифт для остальных
            }
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate (Swipe to Delete)

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем запись из массива
            userScoreArrayOfDictionaries.remove(at: indexPath.row)
            
            // Сохраняем обновлённый массив в UserDefaults
            let userDefaults = UserDefaults.standard
            userDefaults.set(userScoreArrayOfDictionaries, forKey: ViewController.userScoreKey)
            
            // Удаляем строку из таблицы
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .fade)
            }, completion: { _ in
                self.tableView.reloadData() // Обновляем, если требуется
            })
        }
    }
}
