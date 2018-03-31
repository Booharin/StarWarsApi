import UIKit

final class SectionView: UIView {
    private let label = UILabel()
    
    init(name: String?) {
        super.init(frame: .zero)
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = name
        label.textColor = UIColor.white
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(
            x: bounds.minX + 15,
            y: bounds.minY,
            width: bounds.width - 15,
            height: bounds.height
        )
    }
}
