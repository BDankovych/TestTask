
import UIKit

class ImageViewController : UIViewController {
    
    var scrollView: ImageScrollView!
    @IBOutlet weak var controlElementsView: UIView!
    
    static let identifier: String = String(describing: ImageViewController.self)
    
    var photo: Photo!
    
    override func viewDidLoad() {
        setupScrollView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupScrollView() {
        scrollView = ImageScrollView(image: photo.image)
        scrollView.frame = view.frame
        view.addSubview(scrollView)
        view.bringSubviewToFront(controlElementsView)
    }
    
    @IBAction func closePressed() {
        dismiss(animated: true)
    }
    
    @IBAction func infoPressed() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: PhotoDetailsViewController.identifier) as? PhotoDetailsViewController else {
            return
        }
        vc.photo = photo
        present(vc, animated: true)
    }
}

