

import UIKit


class BaseView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureXib()
    }
    
    func configureXib() {
        let nibName = type(of: self).description().components(separatedBy: ".").last ?? ""
        guard let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView else { return }
        self.addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loaded()
    }
    
    
    func loaded() {
        
    }
}
