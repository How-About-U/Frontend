
import UIKit
import Alamofire



class ChatViewController: UIViewController {
    var userTk:UserTk?
    var opnList:[Opinion] = []
    var user:User?
    var getcount = 0
    
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatStackView: UIStackView!
    var stackViewYValue = CGFloat(0)
    @IBOutlet weak var chatTextField: UITextField!
    var a = CGRect()
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //configureRefreshControl()
        //appendList()
        
        //print(userTk)
        
        self.getOpn()
        //print("userTk:\(userTk)")
        //print("opnList:\(opnList)")
        chatTextField.delegate = self
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.prefetchDataSource = self
        
        chatTableView.separatorStyle = .none
        chatTableView.rowHeight = UITableView.automaticDimension
        
        let nibName = UINib(nibName: "ChatCell", bundle: nil)
        chatTableView.register(nibName, forCellReuseIdentifier: "ChatCell")
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyBoardup), name: UIResponder.keyboardWillShowNotification, object: nil)
                
                // 키보드 내려올 때.
        //NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func configureRefreshControl () {
        chatTableView.refreshControl = UIRefreshControl()
        chatTableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }

    @objc func handleRefreshControl() {
       
       DispatchQueue.main.async {
          self.chatTableView.refreshControl?.endRefreshing()
       }
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardup(noti: Notification){
        print("qweqwe")
        
        if let keyboardFrame = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            
            let keyboardHeight = keyboardFrame.height
            self.keyboardHeightConstraint.constant = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
            
            if(stackViewYValue == 0){
                stackViewYValue = self.chatStackView.frame.origin.y
            }

            if self.chatStackView.frame.origin.y == stackViewYValue{
                stackViewYValue = self.chatStackView.frame.origin.y
                self.chatStackView.frame.origin.y -= keyboardFrame.size.height - self.view.safeAreaInsets.bottom
                self.chatStackView.layoutIfNeeded()
            }
            
            print("up!!!!!!!!!")
            print("stackViewYValue : \(stackViewYValue)")
            print("self.chatStackView.frame.origin.y : \(self.chatStackView.frame.origin.y)")
            print("keyboardFrame.size.height : \(keyboardFrame.size.height)")

        }
        

        
        
        
        
    }
        
    @objc func keyBoardDown(noti: Notification){
        

        if self.chatStackView.frame.origin.y != stackViewYValue{
            self.chatStackView.frame.origin.y = stackViewYValue
            self.view.layoutIfNeeded()
        }
        self.keyboardHeightConstraint.constant = 0
        print("down!!!!!!!!!")
        print("stackViewYValue : \(stackViewYValue)")
        print("self.chatStackView.frame.origin.y : \(self.chatStackView.frame.origin.y)")
        
        
    }
    
    func appendList(){
        for opinion in getcount...getcount+9{
            if(opinion >= opnList.count){
                break
            }
            else{
                opnList.append(opnList[opinion])
            }
        }
        getcount += 10
       
        
        chatTableView.reloadData()
        
    }
    
    
    func getOpn() {
        let url = "http://54.180.199.139:8080/api/opin/getOpin"
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
                print("getOpnValue : \(value)")

                do{

                    let dataJSon = try JSONSerialization.data(withJSONObject: value, options: [])
                    let opnlist = try JSONDecoder().decode([Opinion].self, from: dataJSon)
                    //print(opnlist)
                    //self.list.append(opnlist)
                    self.opnList = opnlist
                    print(self.opnList)
                    DispatchQueue.main.async {
                        self.chatTableView.reloadData()
                    }

                } catch {
                    print("decoding error")
                }

            case .failure(let error):
                print("error : \(error)")
                break;
            }
        }
        
    }
    
    
    func postOpn(){
        let url = "http://54.180.199.139:8080/api/opin/save"
        let header : HTTPHeaders = [
                        "Content-Type" : "application/json"
                    ]
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.headers = header
        //request.timeoutInterval = 10

        // POST 로 보낼 정보
        let params = ["content": chatTextField.text,
                      "token": userTk?.token,
                      "vote": true] as [String : Any]

        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }

        AF.request(request).responseString { [weak self] (response) in
            guard let self = self else { return }
            switch response.result {
            case .success:
                print(" OPN POST 성공!!")
                print("response:\(response)")
                self.opnList.append(Opinion(content: self.chatTextField.text!, topic_title: "", user_grade: "", user_name: self.userTk!.username, vote: true))
                DispatchQueue.main.async {
                    self.chatTextField.text = ""
                    self.chatTableView.reloadData()
                }
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
    
    
    
    @IBAction func tapSendButton(_ sender: UIButton) {
        self.postOpn()
        
        
        //chatTableView.reloadData()

        scrollToBottom()
    }
    
   
    
    func scrollToBottom(){

        let indexPath = IndexPath(row: opnList.count-1, section: 0)

        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)

    }
    
 
}

extension ChatViewController: UITextFieldDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true) // 키보드 있을때 스크롤 드래그시 키보드 사라짐
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // 화면 터치시 키보드 내려감
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // TextField 비활성화
        return true
    }
    
    
}

extension ChatViewController: UITableViewDelegate,UITableViewDataSource,UITableViewDataSourcePrefetching{
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        indexPaths.forEach{
            if ($0.row + 1) == getcount{
                 appendList()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opnList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        if opnList[indexPath.row].vote {
            cell.chatStackView.layer.borderColor = UIColor.red.cgColor
            cell.chatStackView.layer.borderWidth = 1
        }
        else{
            cell.chatStackView.layer.borderColor = UIColor.blue.cgColor
            cell.chatStackView.layer.borderWidth = 1
        }
        cell.usernameLabel.text = "\(opnList[indexPath.row].user_name)"
        cell.contentLabel.text = "\(opnList[indexPath.row].content)"
        
        print("Rows: \(indexPath.row)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    
    
}
