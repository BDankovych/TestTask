
import UIKit

extension UIFont {
    
    fileprivate static var latoName: String {
        return "Lato"
    }
    
    enum FontType: String {
        case Black
        case BlackItalic
        case Bold
        case BoldItalic
        case Hairline
        case HairlineItalic
        case Heavy
        case heavyItalic
        case Italic
        case Light
        case LightItalic
        case Medium
        case MediumItalic
        case Regular
        case Semibold
        case SemiboldItalic
        case Thin
        case ThinItalic
    }
    
    static func lato(_ type: FontType, size: CGFloat) -> UIFont {
        return UIFont(name: "\(latoName)-\(type.rawValue)", size: size) ?? UIFont()
    }
}
