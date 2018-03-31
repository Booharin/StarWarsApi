import UIKit

class ObjectCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel?
    
    override func prepareForReuse() {
        name = nil
    }
    
    var name: String? {
        didSet {
            nameLabel?.text = name
        }
    }
    
    var id: Int16?
}

