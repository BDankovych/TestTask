

import Foundation
import Moya
import Result

class ErrorPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        print(request.request?.url)
    }

    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        switch result {
        case .failure(let error):
            ErrorAlertService.shared.process(error: error.errorDescription ?? "DEFAULT_ERROR".localized())
        case .success(let response):
            if response.statusCode < 200 || response.statusCode >= 300 {
                ErrorAlertService.shared.process(error: "DEFAULT_ERROR".localized())
            }
        }
    }
}
