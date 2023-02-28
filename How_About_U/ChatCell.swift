
import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var chatStackView: UIStackView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        chatStackView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
