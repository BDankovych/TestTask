

import UIKit

extension UICollectionViewCell {
    
    static var identefier: String {
        return String(describing: self.self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.identefier, bundle: nil)
    }
}
