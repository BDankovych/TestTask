
import UIKit

final class ErrorAlertService {
    static let shared = ErrorAlertService()
    
    fileprivate var topView: UIView? {
        return AppDelegate.shared.window
    }
    
    func process(error: String) {
//        guard let string = error.details?.errorKey?.localized() else {
//            return
//        }
        present(with: error)
    }
    
    func present(with string: String) {
        if let topView = topView {
            let toast = ToastView(frame: CGRect())
            toast.text = string
            toast.present(on: topView)
        }
    }
}
