
import ObjectMapper


enum PhotoOrder: String {
    case latest
    case oldest
    case popular
}

class GetPhotosModel: Mappable {

    private var page: Int
    private var photosPerPage: Int
    private var orderBy: PhotoOrder
    
    
    private enum JSONKeys: String {
        case page = "page"
        case photosPerPage = "per_page"
        case orderBy = "order_by"
    }
    
    
    init() {
        self.page = 1
        self.photosPerPage = 10
        self.orderBy = .latest
    }
    
    convenience init(page: Int, photosPerPage: Int, orderBy: PhotoOrder = .latest) {
        self.init()
        self.orderBy = orderBy
        self.page = page
        self.photosPerPage = photosPerPage
    }
    
    required init?(map: Map) {
        return nil
    }
    
    func mapping(map: Map) {}
    
    func toJSON() -> [String : Any] {
        return [
            JSONKeys.page.rawValue: page,
            JSONKeys.photosPerPage.rawValue: photosPerPage,
            JSONKeys.orderBy.rawValue: orderBy.rawValue
        ]
    }
}
