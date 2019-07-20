

import ObjectMapper


enum PhotoOrientation: String {
    case lanscape
    case portrait
    case squarish
}

class SearchPhotosModel: Mappable {
    
    
    
    private var query: String
    private var page: Int
    private var photosPerPage: Int
    private var orientation: PhotoOrientation
    
    private enum JSONKeys: String {
        case page = "page"
        case photosPerPage = "per_page"
        case query = "query"
        case orientation = "orientation"
    }
    
    init(query: String) {
        self.query = query
        self.page = 1
        self.photosPerPage = 10
        self.orientation = .portrait
    }
    
    convenience init(query: String, page: Int, photosPerPage: Int, orientation: PhotoOrientation = .portrait) {
        self.init(query: query)
        self.page = page
        self.photosPerPage = photosPerPage
        self.orientation = orientation
    }
    
    required init?(map: Map) {
        return nil
    }
    
    func mapping(map: Map) {}
    
    func toJSON() -> [String : Any] {
        return [
            JSONKeys.query.rawValue: query,
            JSONKeys.page.rawValue: page,
            JSONKeys.photosPerPage.rawValue: photosPerPage,
            JSONKeys.orientation.rawValue: orientation.rawValue
        ]
    }
    
}
