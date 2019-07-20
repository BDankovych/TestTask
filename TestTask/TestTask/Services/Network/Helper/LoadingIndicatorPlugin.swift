

import Foundation
import Moya
import Result

class LoadingIndicatorPlugin: PluginType {
    fileprivate var window: UIWindow?
    fileprivate var count = 0 {
        didSet {
            if count == 0 {
                window?.resignKey()
                window?.rootViewController = nil
                window = nil
            }
        }
    }
    fileprivate weak var activitiIndicatorController: UIViewController?
    
    func willSend(_ request: RequestType, target: TargetType) {
        DispatchQueue.main.async {
            if self.activitiIndicatorController == nil {
                let window = UIWindow(frame: UIScreen.main.bounds)
                window.backgroundColor = .clear
                window.windowLevel = UIWindow.Level.alert
                window.makeKeyAndVisible()
                let activitiIndicatorController = LoadingViewController()
                window.rootViewController = activitiIndicatorController
                activitiIndicatorController.viewWillAppear(false)
                self.window = window
                self.activitiIndicatorController = activitiIndicatorController
            }
            self.count += 1
        }
    }

    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        count -= 1
    }
}
