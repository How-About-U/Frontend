
import UIKit

class LoginViewController: UIViewController {
    
    let userList:[User] = [.init(email: "aaaaa", password: "aaaaa11!", username: "aaa", gender: "남"),.init(email: "bbbbb", password: "bbbbb11!", username: "bbb", gender: "남"),.init(email: "ccccc", password: "ccccc11!", username: "ccc", gender: "여")]
    
    

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        [idTextField,pwTextField].forEach{
            drawUnderLine(textField: $0)
            
        }
        
        [loginButton,signupButton].forEach{
            $0?.layer.cornerRadius = 20
        }
    }

    @IBAction func tapLoginButton(_ sender: UIButton) {
        
        
//        for user in userList{
//            if(user.email == idTextField.text && user.password == pwTextField.text){
//                guard let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {return}
//                mainViewController.modalPresentationStyle = .fullScreen
//                self.present(mainViewController, animated: true)
//            }
//            else{
//                let alert = UIAlertController(title: "아이디 또는 비밀번호가 틀렸습니다.", message: "아이디 또는 비밀번호를 확인해주세요.", preferredStyle: .alert)
//
//                let checkButton = UIAlertAction(title: "확인", style: .cancel )
//
//                alert.addAction(checkButton)
//                self.present(alert, animated: true)
//            }
//        }
        
//        guard let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {return}
//        mainViewController.modalPresentationStyle = .fullScreen
//        self.present(mainViewController, animated: true)
        
        guard let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController else {return}
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
        
        
        
    }
    
    @IBAction func tapSignupButton(_ sender: UIButton) {
        guard let signupViewController = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController else {return}
        signupViewController.modalPresentationStyle = .fullScreen
        self.present(signupViewController, animated: true)
        
    }
    
    func drawUnderLine(textField: UITextField){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor

        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)

        border.borderWidth = width

        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    
}

