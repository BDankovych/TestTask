

import UIKit

class PhotoViewController: UIViewController {

    
    
    let provider = Networking<PhotosApi>.newDefaultNetworking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        provider.makeMappableArrayRequest(target: .getPhotos(photoModel()), resultType: Photo.self, success: { (result) in
            
            print(result!)
            
        }) { (error) in
            print(error)
        }
    }

    
    
    private func photoModel() -> GetPhotosModel {
        let model = GetPhotosModel(page: 1, photosPerPage: 30)
        return model
    }

}

