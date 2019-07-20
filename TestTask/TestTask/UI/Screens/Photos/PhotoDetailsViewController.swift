

import UIKit


class PhotoDetailsViewController: UIViewController {
    
    static let identifier: String = String(describing: PhotoDetailsViewController.self)
    
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInfo()
    }
    
    func configureInfo() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        if let createdDate = photo.createAt {
            createdDateLabel.text = formatter.string(from: createdDate)
        } else {
            createdDateLabel.text = "-"
        }
        if let updatedDate = photo.updatedAt {
            updatedDateLabel.text = formatter.string(from: updatedDate)
        } else {
            updatedDateLabel.text = "-"
        }
        
        descriptionLabel.text = photo.description ?? photo.altDescription ?? "-"
    }
    
    @IBAction func backPressed() {
        dismiss(animated: true)
    }
}
