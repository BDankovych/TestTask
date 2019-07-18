

import UIKit

extension UICollectionView {
    func dequeueCell<cell: UICollectionViewCell>(_ cell: cell.Type, indexPath: IndexPath) -> cell {
        guard let resCell = self.dequeueReusableCell(withReuseIdentifier: cell.identefier, for: indexPath) as? cell else {
            fatalError("Couldn't dequeue \(cell) from \(self)")
        }
        return resCell
    }
    
    func register<cell: UICollectionViewCell>(_ cell: cell.Type) {
        self.register(cell.nib, forCellWithReuseIdentifier: cell.identefier)
    }
}
