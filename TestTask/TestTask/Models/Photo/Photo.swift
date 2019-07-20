

import ObjectMapper
import UIKit

class PhotoUrls: Mappable {
    
    var raw: String?
    var full: String?
    var regular: String?
    var small: String?
    var thumb: String?
    
    private enum JSONKeys: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    required init?(map: Map) {
        if map.JSON[JSONKeys.full.rawValue] == nil && map.JSON[JSONKeys.small.rawValue] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        raw <- map[JSONKeys.raw.rawValue]
        full <- map[JSONKeys.full.rawValue]
        regular <- map[JSONKeys.regular.rawValue]
        small <- map[JSONKeys.small.rawValue]
        thumb <- map[JSONKeys.thumb.rawValue]
    }
    
}

class Photo: Mappable {
    
    var id: String?
    var createAt: Date?
    var updatedAt: Date?
    var height: Int?
    var width: Int?
    var description: String?
    var altDescription: String?
    var urls: PhotoUrls?
    
    var image: UIImage?
    
    private enum JSONKeys: String {
        case id
        case createAt = "created_at"
        case updatedAt = "updated_at"
        case height
        case width
        case description
        case altDescription = "alt_description"
        case urls
    }
    
    required init?(map: Map) {
        var id: String?
        var urls: PhotoUrls?
        
        id <- map[JSONKeys.id.rawValue]
        urls <- map[JSONKeys.urls.rawValue]
        
        if id == nil || urls == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        id <- map[JSONKeys.id.rawValue]
        createAt <- (map[JSONKeys.createAt.rawValue], ISO8601DateTransform())
        updatedAt <- (map[JSONKeys.updatedAt.rawValue], ISO8601DateTransform())
        height <- map[JSONKeys.height.rawValue]
        width <- map[JSONKeys.width.rawValue]
        description <- map[JSONKeys.description.rawValue]
        altDescription <- map[JSONKeys.altDescription.rawValue]
        urls <- map[JSONKeys.urls.rawValue]
    }
}
