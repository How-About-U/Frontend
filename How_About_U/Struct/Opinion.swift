
import Foundation

struct Opinion:Decodable{
    
    let content: String
    let topic_title: String
    let user_grade: String
    let user_name: String
    let vote: Bool
    
}
