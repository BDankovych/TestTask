

import ObjectMapper

class SearchResult: Mappable {
    
    var total: Int?
    var totalPages: Int?
    var results: [Photo]?
    
    
    private enum JSONKeys: String {
        case total
        case totalPages = "total_pages"
        case results
    }
    
    required init?(map: Map) {
        var total: Int?
        var results: [Photo]?
        
        total <- map[JSONKeys.total.rawValue]
        results <- map[JSONKeys.results.rawValue]
        
        if total == nil || results == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        total <- map[JSONKeys.total.rawValue]
        totalPages <- map[JSONKeys.totalPages.rawValue]
        results <- map[JSONKeys.results.rawValue]
    }
    
    
}
