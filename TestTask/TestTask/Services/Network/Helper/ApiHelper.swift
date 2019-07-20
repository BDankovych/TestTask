

import Foundation
import Moya
import Result
import ObjectMapper
import Moya_ObjectMapper

typealias ApiFailureClosure = (String) -> Void
typealias ApiSuccessClosure = () -> Void
typealias ApiDataResultClosure = (Data?) -> Void
typealias ApiMappableResultClosure = (Mappable?) -> Void
typealias ApiMappableArrayResultClosure = ([Mappable?]?) -> Void


struct ApiHelper {
    let defautErrorMessage = "DEFAULT_ERROR_MESSAGE".localized()
    
    func handleResultToJson(result: Result<Moya.Response, MoyaError>)
        -> (Bool, Any?, String?) {
            print(result)
            var isSuccessfull = true
            var object: Any?
            var message = ""
            
            switch result {
            case let .success(response):
                print(response)
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        if let dictionary = try response.mapJSON() as? [String: Any] {
                            object = dictionary
                        } else if let array = try response.mapJSON() as? Array<Any> {
                            object = array
                        }
                    } catch {
                        isSuccessfull = false
                    }
                } else {
                    isSuccessfull = false
                    message = mapError(response: response)
                }
            case let .failure(error):
                let error = error as CustomStringConvertible
                message = error.description
                isSuccessfull = false
            }
            print(object)
            return (isSuccessfull, object, message)
    }
    
    func handleResult(result: Result<Moya.Response, MoyaError>)
        -> (Bool, Data?, String?) {
            print(result)
            var isSuccessfull = true
            var object: Data?
            var message = ""
            
            switch result {
            case let .success(response):
                print(response)
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    object =  response.data
                } else {
                    isSuccessfull = false
                    message = mapError(response: response)
                }
            case let .failure(error):
                let error = error as CustomStringConvertible
                message = error.description
                isSuccessfull = false
            }
            return (isSuccessfull, object, message)
    }
    
    func handleResult<T: Mappable>(type: T.Type, result: Result<Moya.Response, MoyaError>)
        -> (Bool, T?, String?) {
            var isSuccessfull = true
            var object: T?
            var message = ""
            
            switch result {
            case let .success(response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        object = try response.mapObject(T.self)
                        print(try response.mapJSON())
                    } catch {
                        isSuccessfull = false
                    }
                } else {
                    isSuccessfull = false
                    message = mapError(response: response)
                }
            case let .failure(error):
                let error = error as CustomStringConvertible
                message = error.description
                isSuccessfull = false
            }
            return (isSuccessfull, object, message)
    }
    
    func handleResultArray<T: Mappable>(type: T.Type, result: Result<Moya.Response, MoyaError>)
        -> (Bool, [T]?, String?) {
            var isSuccessfull = true
            var object: [T]?
            var message = ""
            
            switch result {
            case let .success(response):
                print(response)
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    do {
                        object = try response.mapArray(type)
                    } catch {
                        isSuccessfull = false
                    }
                } else {
                    isSuccessfull = false
                    message = mapError(response: response)
                }
            case let .failure(error):
                let error = error as CustomStringConvertible
                message = error.description
                isSuccessfull = false
            }
            return (isSuccessfull, object, message)
    }
    
    func mapError(response: Moya.Response) -> String {
        do {
            print(try response.mapString())
            let dict = try response.mapJSON() as? [String: Any]
            if let error = dict?["error"] as? [String: Any], let message = error["description"] as? String {
                return message
            }
            if let message = dict?["error_description"] as? String {
                return message
            }
            return defautErrorMessage
        } catch {
            return defautErrorMessage
        }
    }
}
