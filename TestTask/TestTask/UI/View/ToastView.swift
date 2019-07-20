
import UIKit

class ToastView: UIView {
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            ])
        
        label.setNeedsLayout()
        label.layoutIfNeeded()
        
        return label
    }()
    
    var text: String? {
        set {
            label.text = newValue
            label.sizeToFit()
        }
        get {
            return label.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.toastGray
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }
    
    func present(on view: UIView) {
        view.addSubview(self)
        
        let bottomConstraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
            bottomConstraint,
            topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            ])
        view.layoutIfNeeded()
        alpha = 0.1
        setup()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            bottomConstraint.constant = -78 - (self.label.bounds.height + 20)
            self.alpha = 1
            view.layoutIfNeeded()
        }, completion: { (_) in
            UIView.animate(withDuration: 0.3, delay: 3, options: .curveEaseIn, animations: {
                self.alpha = 0
            }, completion: { (_) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                    self.removeFromSuperview()
                })
            })
        })
    }
}
