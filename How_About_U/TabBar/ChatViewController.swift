
import UIKit

var list:[Opinion] = [.init(user: "0", content: "0"), .init(user: "1", content: "1"), .init(user: "2", content: "2222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222"), .init(user: "3", content: "33333333333333333333333333333333333333333333333333333333"), .init(user: "4", content: "4"), .init(user: "5", content: "5"), .init(user: "6", content: "6"), .init(user: "7", content: "777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777"), .init(user: "8", content: "8"), .init(user: "9", content: "9"), .init(user: "10", content: "10"), .init(user: "11", content: "11"), .init(user: "12", content: "12"), .init(user: "13", content: "13"), .init(user: "14", content: "14"), .init(user: "15", content: "15"), .init(user: "16", content: "16"), .init(user: "17", content: "17"), .init(user: "18", content: "18"), .init(user: "19", content: "19"), .init(user: "20", content: "20"), .init(user: "21", content: "21"), .init(user: "22", content: "22"), .init(user: "23", content: "23"), .init(user: "24", content: "24"), .init(user: "25", content: "25"), .init(user: "26", content: "26"), .init(user: "27", content: "27"), .init(user: "28", content: "28"), .init(user: "29", content: "29"), .init(user: "30", content: "30"), ]

class ChatViewController: UIViewController {
    let user = User(email: "a", password: "a", username: "aa", gender: "남")
    var opinionList:[Opinion] = []
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
        
        for opinin in 31...45{
            list.append(.init(user: "\(opinin)", content: "\(opinin)"))
        }
        configureRefreshControl()
        appendList()
        
        chatTextField.delegate = self
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.prefetchDataSource = self
        
        chatTableView.separatorStyle = .none
        chatTableView.rowHeight = UITableView.automaticDimension
        
        let nibName = UINib(nibName: "ChatCell", bundle: nil)
        chatTableView.register(nibName, forCellReuseIdentifier: "ChatCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardup), name: UIResponder.keyboardWillShowNotification, object: nil)
                
                // 키보드 내려올 때.
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
            if(opinion >= list.count){
                break
            }
            else{
                opinionList.append(list[opinion])
            }
        }
        getcount += 10
       
        
        chatTableView.reloadData()
        
    }
    
    
    
    @IBAction func tapSendButton(_ sender: UIButton) {
        opinionList.append(.init(user: user.username, content: chatTextField.text!))
        
        chatTextField.text = ""
        chatTableView.reloadData()
        
        scrollToBottom()
    }
    
    func scrollToBottom(){
        
        let indexPath = IndexPath(row: opinionList.count-1, section: 0)
        
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
        return opinionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else { return UITableViewCell()}
        cell.selectionStyle = .none
        cell.usernameLabel.text = "\(opinionList[indexPath.row].user)"
        cell.contentLabel.text = "\(opinionList[indexPath.row].content)"
        
        print("Rows: \(indexPath.row)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    
    
}
