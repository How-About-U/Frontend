
import Foundation

struct User{
    var email:String
    var password:String
    var username:String
    var gender:String
    
    init(email: String, password: String, username: String, gender: String) {
        self.email = email
        self.password = password
        self.username = username
        self.gender = gender
    }
}
