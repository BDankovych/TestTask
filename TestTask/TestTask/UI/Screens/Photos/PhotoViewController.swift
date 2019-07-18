

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let provider = Networking<PhotosApi>.newDefaultNetworking()
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        provider.makeMappableArrayRequest(target: .getPhotos(photoModel()), resultType: Photo.self, success: { (result) in
            
            self.photos = result ?? []
            self.collectionView.reloadData()
        }) { (error) in
            print(error)
        }
    }

    private func configureView() {
        collectionView.register(PhotoAlbumCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func photoModel() -> GetPhotosModel {
        let model = GetPhotosModel(page: 1, photosPerPage: 30)
        return model
    }

}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.width / 3 - 10
        
        return CGSize(width: size, height: size)
    }
}

extension PhotoViewController: UICollectionViewDelegate {
    
}

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueCell(PhotoAlbumCollectionViewCell.self, indexPath: indexPath)
        cell.setupDefaultActivity()
        
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
        
        let photo = photos[forItemAt.item]
        if let imageUrl = photo.urls?.full {
            PhotoDownloadService.shared.cancelDownload(url:imageUrl)
        }
    }
    
    
}
