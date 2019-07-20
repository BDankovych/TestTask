

import Moya


class PhotoDownloadService {
    
    static let shared = PhotoDownloadService()
    
    var tasks: [String: Cancellable]
    let provier = Networking<FileServiceApi>.newDefaultNetworking(silentMode: true)
    
    private init() {
        tasks = [:]
    }
    
    
    func downloadImage(urlString: String, success: @escaping ApiDataResultClosure, failure: @escaping ApiFailureClosure) {
        guard let url = URL(string: urlString) else { return }
        tasks[urlString] = provier.makeRequest(target: .download(url: url), success: success, failure: failure)
    }
    
    func cancelDownload(url: String) {
        DispatchQueue.main.async {
            self.tasks[url]?.cancel()
        }
    }
    
    func calcelAllTask() {
        DispatchQueue.main.async {
            self.tasks.forEach{ $0.value.cancel() }
        }
    }
}
