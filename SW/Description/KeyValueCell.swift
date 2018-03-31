import UIKit

class KeyValueCell: UITableViewCell {

    @IBOutlet private weak var keyLabel: UILabel?
    @IBOutlet private weak var valueLabel: UILabel?
    
    func setData(key: String, value: String) {
        keyLabel?.text = key
        valueLabel?.text = value
    }
}
