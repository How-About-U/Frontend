
import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    var userList:[User] = []

    var userTk:UserTk? = .init(email: "", username: "", token: "")
    
    var user:User? = .init(email: "", password: "", username: "", grade: "")
    
    var topic:Topic = .init(title: "")

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var autoLoginButton: UIButton!
    
    var isAutoLogin = false
    
    lazy var alert: UIAlertController = {
        
        let alert = UIAlertController(title: "아이디 또는 비밀번호가 틀렸습니다.", message: "아이디 또는 비밀번호를 확인해주세요.", preferredStyle: .alert)
        
        let checkButton = UIAlertAction(title: "확인", style: .cancel )
        
        alert.addAction(checkButton)
        return alert
    }()
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        if let userId = UserDefaults.standard.string(forKey: "id"){
//            if let userToken = UserDefaults.standard.string(forKey: "pw"){
//                print("loginPage")
//
//                self.goToTabBarController()
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [idTextField,pwTextField].forEach{
            drawUnderLine(textField: $0)
        }
        
        [loginButton,signupButton].forEach{
            $0?.layer.cornerRadius = 20
        }
        
        self.getUsers()
        //self.postTopic()
        
    }
    
    func postLogin() {
        let url = "http://54.180.199.139:8080/api/members/login"
        let header : HTTPHeaders = ["Content-Type" : "application/json"]
        var request = URLRequest(url: URL(string: url)!
        )
        request.httpMethod = "POST"
        request.headers = header
        let params = ["email" : user!.email,
                      "password" : user!.password]
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseJSON { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let obj):
                print("Login POST 성공")
                print("Login POST response : \(response)")
                do{
                    let dataJSon = try JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
                    let userTk = try JSONDecoder().decode(UserTk.self, from: dataJSon)
                    self.userTk = userTk
//                    if self.isAutoLogin {
//                        UserDefaults.standard.set(self.userTk?.email, forKey: "id")
//                        UserDefaults.standard.set(self.userTk?.username, forKey: "username")
//                        UserDefaults.standard.set(self.userTk?.token, forKey: "token")
//                    }
                }catch{}
                self.goToTabBarController()

                
                
                case .failure(let error):
                    print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
                self.present(self.alert, animated: true)
                }
            }
        }
    
    
    func postTopic(){
        let url = "http://54.180.199.139:8080/api/topic/save"
        let header : HTTPHeaders = [
                        "Content-Type" : "application/json"
                    ]
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.headers = header
        //request.timeoutInterval = 10
        
        // POST 로 보낼 정보
        let params = ["title": topic.title]

        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print(" Topic POST 성공!!")
                print("response:\(response)")
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    func getUsers() {
        let url = "http://54.180.199.139:8080/api/members/users"
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json"])
        .validate(statusCode: 200..<300)
        
        .responseJSON{ [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let value):
                //print("valueGetUser : \(value)")

                do{
                    
                    let dataJSon = try JSONSerialization.data(withJSONObject: value, options: [])
                    let userlist = try JSONDecoder().decode([User].self, from: dataJSon)
                    //print("userlist : \(userlist)")
                    self.userList = userlist

                } catch {
                    print("decoding error")
                }

            case .failure(let error):
                print("error : \(error)")
                break;
            }
        }
        
    }
    
    
    
    

    @IBAction func tapLoginButton(_ sender: UIButton) {
        
        guard let email = idTextField.text, let password = pwTextField.text else {return}
        
        user?.email = email
        user?.password = password
        
        for userl in userList{
            if email == userl.email{
                self.user?.grade = userl.grade
                self.user?.username = userl.username
            }
        }
        
        self.postLogin()
        
    }
    
    @IBAction func tapSignupButton(_ sender: UIButton) {
        guard let signupViewController = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController else {return}
        signupViewController.modalPresentationStyle = .fullScreen
        signupViewController.userList = self.userList
        self.present(signupViewController, animated: true)
        
    }
    
    @IBAction func tapAutoLoginButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true{
            isAutoLogin = true
        }
        else{
            isAutoLogin = false
        }
        
        
    }
    
    func goToTabBarController(){
        guard let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController else {return}
        guard let mainView = tabBarController.viewControllers![1] as? MainViewController else {return}
        guard let chatView = tabBarController.viewControllers![0] as? ChatViewController else {return}
        mainView.userTk = self.userTk
        mainView.user = self.user
        chatView.userTk = self.userTk
        chatView.user = self.user
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
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

