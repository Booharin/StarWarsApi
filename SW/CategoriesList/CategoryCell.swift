import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var iconImageView: UIImageView?
    
    var data: CategoryData? {
        didSet {
            titleLabel?.text = data?.title
            iconImageView?.image = data?.icon
        }
    }
}
