import UIKit

class SingleValueCell: UITableViewCell {

    @IBOutlet private weak var valueLabel: UILabel?
    
    var value: String? {
        didSet {
            valueLabel?.text = value
        }
    }
}
