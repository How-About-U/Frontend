
import UIKit

class SignupViewController: UIViewController {
    
    var userList:[User] = [.init(email: "aaaaa", password: "aaaaa11!", username: "aaa", gender: "남"),.init(email: "bbbbb", password: "bbbbb11!", username: "bbb", gender: "남"),.init(email: "ccccc", password: "ccccc11!", username: "ccc", gender: "여")]
    
    var user:User = .init(email: "", password: "", username: "", gender: "남")
    
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet weak var idErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var repasswordTextField: UITextField!
    @IBOutlet weak var repasswordErrorLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var nicknameErrorLabel: UILabel!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var completeSignupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completeSignupButton.isEnabled = false
        
        idErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        repasswordErrorLabel.isHidden = true
        nicknameErrorLabel.isHidden = true
        
        
        idTextField.delegate = self
        passwordTextField.delegate = self
        repasswordTextField.delegate = self
        nicknameTextField.delegate = self
        
        idTextField.addTarget(self, action: #selector(isValidID), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(isValidPassword), for: .editingChanged)
        repasswordTextField.addTarget(self, action: #selector(isSamePassword), for: .editingChanged)
        nicknameTextField.addTarget(self, action: #selector(isValidNickname), for: .editingChanged)
    }
    
    @objc func isValidID(){
        idErrorLabel.isHidden = false
        
        let minCount = 5
        let maxCount = 12
        let count = idTextField.text!.count
        
        switch count{
        case 0:
            idErrorLabel.text = "아이디를 입력해주세요."
        case 1..<minCount:
            idErrorLabel.text = "아이디는 5글자 이상입니다."
        case minCount...maxCount:
            let idPattern = "^[A-Za-z0-9]{\(minCount),\(maxCount)}$"
            let isValidPattern = (idTextField.text!.range(of: idPattern, options: .regularExpression) != nil)
            if isValidPattern {
                idErrorLabel.text = "조건에 맞는 아이디입니다."
                idErrorLabel.isHidden = true
            }
            else{
                idErrorLabel.text = "알파벳,숫자만 사용 가능합니다."
            }
        default:
            idErrorLabel.text = "아이디는 12글자 이하입니다."
        }
    }
    
    @objc func isValidPassword(){
        passwordErrorLabel.isHidden = false
                
        let minCount = 8
        let maxCount = 16
        let count = passwordTextField.text!.count

        switch count {
        case 0:
            passwordErrorLabel.text = "비밀번호를 입력해주세요."
        case 1..<minCount:
            passwordErrorLabel.text = "비밀번호는 8글자 이상입니다."
        case minCount...maxCount:
            let idPattern = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{\#(minCount),\#(maxCount)}$"#
            let isVaildPattern = (passwordTextField.text!.range(of: idPattern, options: .regularExpression) != nil)
            if isVaildPattern {
                passwordErrorLabel.text = "조건에 맞는 비밀번호입니다."
                passwordErrorLabel.isHidden = true
            } else {
                passwordErrorLabel.text = "영어알파벳, 숫자, 특수문자가 필수로 입력되어야 합니다."
            }
        default:
            passwordErrorLabel.text = "비밀번호는 16글자 이하입니다."
        }
    }
    
    
    @objc func isSamePassword(){
        
        if(passwordTextField.text != repasswordTextField.text){
            repasswordErrorLabel.text = "비밀번호가 다릅니다."
            repasswordErrorLabel.isHidden = false
            
        }
        else{
            repasswordErrorLabel.isHidden = true
            
        }
        
    }
    
    @objc func isValidNickname(){
        nicknameErrorLabel.isHidden = false
                
        let minCount = 3
        let maxCount = 10
        let count = nicknameTextField.text!.count

        switch count {
        case 0:
            nicknameErrorLabel.text = "닉네임을 입력해주세요."
        case 1..<minCount:
            nicknameErrorLabel.text = "닉네임은 3글자 이상입니다."
        case minCount...maxCount:
            let idPattern = "^[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9$@$!%*#?&]{\(minCount),\(maxCount)}$"
            let isVaildPattern = (nicknameTextField.text!.range(of: idPattern, options: .regularExpression) != nil)
            if isVaildPattern {
                nicknameErrorLabel.text = "조건에 맞는 닉네임입니다."
                nicknameErrorLabel.isHidden = true
            } else {
                nicknameErrorLabel.text = "한글,영어알파벳,숫자,특수문자가 입력되어야 합니다."
            }
        default:
            passwordErrorLabel.text = "닉네임은 10글자 이하입니다."
        }
    }
    
    
    @IBAction func tapIDDoubleCheckButton(_ sender: UIButton) {
        var check = false
        for user in userList{
            if(user.email == idTextField.text){
                let alert = UIAlertController(title: "아이디 중복!", message: "다른 아이디를 입력해주세요.", preferredStyle: .alert)
                
                let checkButton = UIAlertAction(title: "확인", style: .cancel )
                
                alert.addAction(checkButton)
                self.present(alert, animated: true)
                check = false
            }
            else{
                check = true
            }
        }
        if check {
            let alert = UIAlertController(title: "가능한 아이디!", message: "아이디가 중복되지 않습니다.", preferredStyle: .alert)
            
            let checkButton = UIAlertAction(title: "확인", style: .cancel )
            
            alert.addAction(checkButton)
            self.present(alert, animated: true)
        }
        
    }
    
    @IBAction func tapNicknameDoubleCheckButton(_ sender: UIButton) {
        var check = false
        for user in userList{
            if(user.email == idTextField.text){
                let alert = UIAlertController(title: "닉네임 중복!", message: "다른 닉네임을 입력해주세요.", preferredStyle: .alert)
                
                let checkButton = UIAlertAction(title: "확인", style: .cancel )
                
                alert.addAction(checkButton)
                self.present(alert, animated: true)
                check = false
            }
            else{
                check = true
            }
        }
        if check {
            let alert = UIAlertController(title: "가능한 닉네임!", message: "닉네임이 중복되지 않습니다.", preferredStyle: .alert)
            
            let checkButton = UIAlertAction(title: "확인", style: .cancel )
            
            alert.addAction(checkButton)
            self.present(alert, animated: true)
        }
    }
    
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func tapGenderSegmentedControl(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0){
            user.gender = "남"
        }
        else{
            user.gender = "여"
        }
    }
    
    @IBAction func tapCompleteSignupButton(_ sender: UIButton) {
        
        guard let email = idTextField.text, let password = passwordTextField.text,let username = nicknameTextField.text else {return}
        
        user.email = email
        user.password = password
        user.username = username
        
        userList.append(user)
        guard let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {return}
        mainViewController.modalPresentationStyle = .fullScreen
        mainViewController.user = self.user
        self.present(mainViewController, animated: true)
    }
}

extension SignupViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = idTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        let isRepasswordEmpty = repasswordTextField.text == ""
        let isNicknameEmpty = nicknameTextField.text == ""
        
        completeSignupButton.isEnabled = !isEmailEmpty && !isPasswordEmpty && !isRepasswordEmpty && !isNicknameEmpty
    }
}
