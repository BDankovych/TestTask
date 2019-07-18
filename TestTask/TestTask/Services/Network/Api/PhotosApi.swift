
import Moya

enum PhotosApi {
    case getPhotos(GetPhotosModel)
    case searchPhotos(SearchPhotosModel)
}


extension PhotosApi: TargetType {
    
    var baseURL: URL {
        return AppConfiguration.default.serverUrl
    }
    
    var path: String {
        switch self {
        case .getPhotos(_):
            return "photos"
        case .searchPhotos(_):
            return "search/photos"
        @unknown default:
            fatalError()
        }
    }
    
    var method: Method {
        switch self {
        case .getPhotos(_):
            return .get
        case .searchPhotos(_):
            return .get
        @unknown default:
            fatalError()
        }
    }
    
    var task: Task {
        let encoding: ParameterEncoding
        switch self.method {
        case .post, .put:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters as? [String : Any] {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    var parameters: Any? {
        switch self {
        case .getPhotos(let model):
            return model.toJSON()
        case .searchPhotos(let model):
            return model.toJSON()
        @unknown default:
            fatalError()
        }
    }
    
    var headers: [String : String]? {
        return [
            "Authorization": "Client-ID " + AppConfiguration.default.clientID
        ]
    }
    
    var sampleData: Data {
        return Data()
    }
    
    
}
