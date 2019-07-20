

import UIKit

protocol PhotoGridViewDelegate: class {
    func photoTapped(_ photo: Photo)
}

class PhotoGridView: BaseView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: PhotoGridViewDelegate?
    var itemsPerRow = 3
    
    var photos = [Photo]() {
        didSet {
            update()
        }
    }
    
    override func loaded() {
        super.loaded()
        configureView()
    }
    
    private func update() {
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        collectionView.reloadData()
    }
    
    private func configureView() {
        collectionView.register(PhotoAlbumCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension PhotoGridView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.width / CGFloat(itemsPerRow) - 10
        
        return CGSize(width: size, height: size)
    }
}

extension PhotoGridView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = photos[safe: indexPath.item],
            let img = photo.image
             else {
                return
        }
        
        delegate?.photoTapped(photo)
        
        
    }
}

extension PhotoGridView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(PhotoAlbumCollectionViewCell.self, indexPath: indexPath)
        //        cell.setupDefaultActivity()
        let photo = photos[indexPath.item]
        //        cell.configure(with: photo)
        cell.imageUrl = photo.urls?.full ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        guard let photoViewCell = cell as? PhotoAlbumCollectionViewCell else { return }
        photoViewCell.configure(with: photo)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying: UICollectionViewCell, forItemAt: IndexPath) {
        
        if collectionView.cellForItem(at: forItemAt) == nil {
            return
        }
        
        
        if let photo = photos[safe: forItemAt.item], let imageUrl = photo.urls?.full {
            PhotoDownloadService.shared.cancelDownload(url:imageUrl)
        }
    }
}
