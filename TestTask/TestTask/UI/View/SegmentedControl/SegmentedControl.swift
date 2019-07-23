

import UIKit

protocol SegmentedControlDelegate: class {
    func segmentedControlValueChanged(control: SegmentedControl)
}


class SegmentedControl: BaseView {
    
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var stackViewWidth: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    
    
    weak var delegate: SegmentedControlDelegate?
    
    var elements: [String] = [] {
        didSet {
            update()
        }
    }
    
    var selectedIndex: Int? {
        didSet {
            if let selectedIndex = selectedIndex {
                setElementVisible(selectedIndex)
            } else {
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
            delegate?.segmentedControlValueChanged(control: self)
        }
    }
    
    override func loaded() {
        super.loaded()
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupRows() {
        leftArrow.isHidden = scrollView.contentOffset.x < widthOfElement
        rightArrow.isHidden = (scrollView.contentOffset.x == scrollView.contentSize.width - scrollView.frame.size.width) || elements.count == 0
        
    }
    
    private var widthOfElement: CGFloat {
        get {
            return 80
        }
    }
    private var itemOffset: CGFloat = 15.0
    
    
    public func update() {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        stackView.spacing = itemOffset
        let width = CGFloat(elements.count) * widthOfElement + CGFloat(elements.count - 1) * itemOffset
        
        stackView.widthAnchor.constraint(equalToConstant: width)
        
        if elements.count > 0 {
            for index in 0 ..< elements.count {
                prepareButton(for: index)
            }
        }
        setupRows()
        layoutSubviews()
    }
    
    private func setElementVisible(_ elementIndex: Int) {
        setupRows()
        var xOffset: CGFloat = 0
        if elementIndex == 0 {
            xOffset = 0
        } else if elementIndex == elements.count - 1 {
            xOffset = scrollView.contentSize.width - scrollView.frame.width
        } else {
            xOffset = CGFloat(elementIndex) * widthOfElement + CGFloat(elementIndex > 0 ? elementIndex - 1 : 0) * itemOffset
        }
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        
    }
    
    
    private func prepareButton(for index: Int) {
        let button = UIButton()

        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        

//        button.titleLabel?.font = UIFont.lato(.Regular, size: 15)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        

        let currentIndex = selectedIndex ?? 0
        let bgColor: UIColor = currentIndex == index ? UIColor(hexString: "#74E897") : .white
        button.backgroundColor = bgColor
        let titleColor: UIColor = currentIndex == index ? .white : .black
        button.setTitleColor(titleColor, for: .normal)
        button.tag = index
        button.setTitle(elements[index], for: .normal)
        
        button.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: widthOfElement).isActive = true
        
        stackView.addArrangedSubview(button)
        
        button.addTarget(self, action: #selector(SegmentedControl.buttonTouchUpInside(sender:)), for: .touchUpInside)

    }
    
    @objc func buttonTouchUpInside(sender: UIButton) {
        
        if sender.tag != selectedIndex {
            selectedIndex = sender.tag
            sender.backgroundColor = UIColor(hexString: "#74E897")
            sender.setTitleColor(.white, for: .normal)
            
            for button in stackView.arrangedSubviews as? [UIButton] ?? [] where button.tag != sender.tag {
                button.backgroundColor = UIColor.white
                button.setTitleColor(.black, for: .normal)
            }
            
            delegate?.segmentedControlValueChanged(control: self)
        }
    }
    
}

extension SegmentedControl: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setupRows()
    }
}
