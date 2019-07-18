

import Moya
import ObjectMapper
import Result

struct Networking<Target> where Target: Moya.TargetType {
    
    fileprivate let provider: MoyaProvider<Target>
    fileprivate let helper = ApiHelper()
    
    func makeRequest(target: Target,
                     success: @escaping ApiSuccessClosure,
                     failure: @escaping ApiFailureClosure) {
        provider.request(target) { (result) in
            let (isSuccessfull, _, message) = self.helper.handleResult(result: result)
            isSuccessfull ? success() : failure(message ?? self.helper.defautErrorMessage)
        }
    }
    
    func makeRequest(target: Target,
                     success: @escaping ApiStringResultClosure,
                     failure: @escaping ApiFailureClosure) {
        provider.request(target) { (result) in
            let (isSuccessfull, str, message) = self.helper.handleResult(result: result)
            isSuccessfull ? success(str) : failure(message ?? self.helper.defautErrorMessage)
        }
    }
    
    func makeMappableRequest<T: Mappable>(target: Target,
                                          resultType: T.Type,
                                          success: @escaping (T?) -> Void,
                                          failure: @escaping ApiFailureClosure) {
        provider.request(target) { (result) in
            let (isSuccessfull, object, message) = self.helper.handleResult(type: resultType, result: result)
            isSuccessfull ? success(object) : failure(message ?? self.helper.defautErrorMessage)
        }
    }
    
    func makeMappableArrayRequest<T: Mappable>(target: Target,
                                               resultType: T.Type,
                                               success: @escaping ([T]?) -> Void,
                                               failure: @escaping ApiFailureClosure) {
        provider.request(target) { (result) in
            let (isSuccessfull, object, message) = self.helper.handleResultArray(type: resultType, result: result)
            isSuccessfull ? success(object) : failure(message ?? self.helper.defautErrorMessage)
        }
    }
    
    func makeUploadRequest(target: Target,
                           success: @escaping ApiStringResultClosure,
                           failure: @escaping ApiFailureClosure) {
        provider.request(target) { (result) in
            let (isSuccessfull, url, message) = self.helper.handleResultToJson(result: result)
            if let url = url as? [String: Any], isSuccessfull {
                success(url["result"] as? String)
            } else {
                failure(message ?? self.helper.defautErrorMessage)
            }
        }
    }

    // MARK: Factory methods
    static func newDefaultNetworking() -> Networking<Target> {
        let provider: MoyaProvider<Target> = newProvider()
        return Networking<Target>(provider: provider)
    }
}


extension Networking {
    static var plugins: [PluginType] {
        return [
            LoadingIndicatorPlugin(),
            ErrorPlugin()
        ]
    }
    
    static fileprivate func newProvider<Target>(plugins: [PluginType] = Networking.plugins,
                                                _ requestClosure: ((Endpoint, @escaping (Result<URLRequest, MoyaError>) -> Void) -> Void)? = nil)
        -> MoyaProvider<Target> {
            if let requestClosure = requestClosure {
                return MoyaProvider(requestClosure: requestClosure, plugins: plugins)
            } else {
                return MoyaProvider(plugins: plugins)
            }
    }
}
