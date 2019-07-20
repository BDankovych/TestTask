

import Moya

enum FileServiceApi {
    case download(url: URL)
    
}

extension FileServiceApi: TargetType {
    var baseURL: URL {
        switch self {
        case .download(let url):
            return url
        @unknown default:
            fatalError()
        }
    }
    
    var path: String {
        switch self {
        case .download(_):
            return ""
        @unknown default:
            fatalError()
        }
    }
    
    var method: Method {
        switch self {
        case .download(_):
            return .get
        @unknown default:
            fatalError()
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
