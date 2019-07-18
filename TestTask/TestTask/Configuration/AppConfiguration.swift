
import Foundation

class AppConfiguration {
    static let `default` = AppConfiguration()
    
    var baseUrlString: String {
        return "https://api.unsplash.com/"
    }
    
    var serverUrl: URL {
        return URL(string: baseUrlString)!
    }
    
    var clientID: String {
        return "4c9fbfbbd92c17a2e95081cec370b4511659666240eb4db9416c40c641ee843b"
    }
    
    private init() { }

}


