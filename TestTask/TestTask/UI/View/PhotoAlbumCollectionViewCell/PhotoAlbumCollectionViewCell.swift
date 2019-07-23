

import UIKit

class PhotoAlbumCollectionViewCell: UICollectionViewCell {
    var imageUrl: String = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func setupDefaultActivity() {
        imageView.image = nil
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopActivity() {
        activityIndicator.stopAnimating()
    }
    
    func configure(with photo: Photo) {
        setupDefaultActivity()
        if let image = photo.image {
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
            }
            imageView.image = image
        } else {
            if let imageUrl = photo.urls?.full {
                self.imageUrl = imageUrl
                PhotoDownloadService.shared.downloadImage(urlString: imageUrl, success: { data in
                    if let data = data {
                        self.performUIUpdatesOnMain {
                            photo.image = UIImage(data: data)
                            if self.imageUrl == imageUrl {
                                self.imageView.image = photo.image
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }) { _ in
                    self.performUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
}
