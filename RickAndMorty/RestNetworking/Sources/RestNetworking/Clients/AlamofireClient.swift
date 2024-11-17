import Foundation

public final class AlamofireClient {
    let requestManager: RequestManager
    
    public init(retryLimit: Int) {
        requestManager = RequestManager(retryLimit: retryLimit)
    }
}
