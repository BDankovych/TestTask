

import UIKit

enum PhotoControllerMode: Int {
    case `default`
    case search
    
    var photoPerRow: Int {
        switch self {
        case .default:
            return 3
        case .search:
            return 1
        @unknown default:
            fatalError()
        }
    }
}

class PhotoViewController: UIViewController {

    @IBOutlet weak var photoGridView: PhotoGridView!
    @IBOutlet weak var segmentControl: SegmentedControl!
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    
    let provider = Networking<PhotosApi>.newDefaultNetworking()
    
    var currentMode = PhotoControllerMode.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoGridView.delegate = self
        searchBar.delegate = self
        setupSegmantedControl()
        segmentControl.selectedIndex =  0
        configureSearchBar(show: false)
    }
    
    private func loadPhotos() {
        provider.makeMappableArrayRequest(target: .getPhotos(photoModel()), resultType: Photo.self, success: { (result) in
            self.photoGridView.photos = result ?? []
        }) { (error) in
            ErrorAlertService.shared.present(with: error)
        }
    }
    
    private func loadSearchPhoto() {
        provider.makeMappableRequest(target: .searchPhotos(searchPhotoModel()), resultType: SearchResult.self, success: { (result) in
            
            self.photoGridView.photos = result?.results ?? []
            
            let totalPages = result?.totalPages ?? 0 > 30 ? 30 : 0
            self.setupSegmantedControl(maxValue: totalPages)
            
        }) { (error) in
            ErrorAlertService.shared.present(with: error)
        }
    }

    private func setupSegmantedControl(maxValue: Int = 30) {
        if maxValue >= 1 {
            segmentControl.elements = Array<Int>(1...maxValue).map{String($0)}
            segmentControl.delegate = self
            
        } else {
            segmentControl.elements = []
            segmentControl.delegate = nil
        }
    }

    private func searchPhotoModel() -> SearchPhotosModel {
        let searchModel = SearchPhotosModel(query: searchBar.text!, page: segmentControl.selectedIndex ?? 0 + 1, photosPerPage: 30)
        return searchModel
    }
    private func photoModel() -> GetPhotosModel {
        let model = GetPhotosModel(page: segmentControl.selectedIndex ?? 0 + 1, photosPerPage: 30)
        return model
    }

    @IBAction func modeValueChanged(_ sender: UISegmentedControl) {
        
        guard let newModeValue = PhotoControllerMode(rawValue: sender.selectedSegmentIndex) else { return }
        
        clearResults()
        currentMode = newModeValue
        photoGridView.itemsPerRow = currentMode.photoPerRow
        if currentMode == .default {
            setupSegmantedControl()
            loadPhotos()
        } else {
            searchBar.text = ""
            setupSegmantedControl(maxValue: 0)
        }
        configureSearchBar(show: currentMode == .search)
    }
    
    
    private func configureSearchBar(show: Bool) {
        searchBar.isHidden = !show
        searchBarHeightConstraint.constant = show ? 56 : 0
    }
    
    private func clearResults() {
        PhotoDownloadService.shared.calcelAllTask()
        photoGridView.photos = []
    }
}

extension PhotoViewController: SegmentedControlDelegate {
    func segmentedControlValueChanged(control: SegmentedControl) {
        clearResults()
        
        if currentMode == .default {
            loadPhotos()
        } else {
            loadSearchPhoto()
        }
    }
}

extension PhotoViewController: PhotoGridViewDelegate {
    func photoTapped(_ photo: Photo) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: ImageViewController.identifier) as? ImageViewController else {
            return
        }
        vc.photo = photo
        present(vc, animated: true)
    }
}

extension PhotoViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text?.count ?? 0 > 3 {
            loadSearchPhoto()
        } else {
            ErrorAlertService.shared.process(error: "Input more than 3 symbols")
        }
    }
}
