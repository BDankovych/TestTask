

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: SegmentedControl!
    
    let provider = Networking<PhotosApi>.newDefaultNetworking()
    var photos = [Photo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupSegmantedControl()
    }
    
    private func loadPhotos() {
        provider.makeMappableArrayRequest(target: .getPhotos(photoModel()), resultType: Photo.self, success: { (result) in
            self.photos = result ?? []
            self.collectionView.reloadData()
        }) { (error) in
            print(error)
        }
    }

    private func setupSegmantedControl() {
        segmentControl.elements = Array<Int>(1...30).map{String($0)}
        segmentControl.delegate = self
        segmentControl.selectedIndex =  0
    }
    
    private func configureView() {
        collectionView.register(PhotoAlbumCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func photoModel() -> GetPhotosModel {
        print(segmentControl.selectedIndex)
        let model = GetPhotosModel(page: segmentControl.selectedIndex ?? 0 + 1, photosPerPage: 30)
        return model
    }

}

extension PhotoViewController: SegmentedControlDelegate {
    func segmentedControlValueChanged(control: SegmentedControl) {
        PhotoDownloadService.shared.calcelAllTask()
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        photos = []
        collectionView.reloadData()
        loadPhotos()
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photo = photos[safe: indexPath.item],
            let img = photo.image,
            let vc = storyboard?.instantiateViewController(withIdentifier: ImageViewController.identifier) as? ImageViewController else {
                return
        }
        
        vc.photo = photo
        present(vc, animated: true)  
    }
}

extension PhotoViewController: UICollectionViewDataSource {
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
