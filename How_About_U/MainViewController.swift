
import UIKit

class MainViewController: UIViewController {
    
    var user:User? = nil

    @IBOutlet weak var voteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user ?? "")
        // Do any additional setup after loading the view.
    }
    

    @IBAction func tapVoteButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "주제", message: "투표해주세요!", preferredStyle: .alert)
        let leftButton = UIAlertAction(title: "빨강", style: .default ,handler: { _ in
            
        })
        let rightButton = UIAlertAction(title: "파랑", style: .default, handler: { _ in
            
        })
        alert.addAction(leftButton)
        alert.addAction(rightButton)
        self.present(alert, animated: true)
        
    }
    

}
