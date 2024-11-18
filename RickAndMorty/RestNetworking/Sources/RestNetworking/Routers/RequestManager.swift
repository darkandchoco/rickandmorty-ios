import Foundation
import Alamofire

struct RequestManager: RequestInterceptor {
    let session: Session
    let retrylimit: Int
    
    public init(retryLimit: Int) {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let networkLogger = NetworkLogger()
        session = Session(configuration: configuration, eventMonitors: [networkLogger])
        self.retrylimit = retryLimit
    }
    
    public enum RequestError: Swift.Error {
        case missingData
        case requestError
        case selfDeallocated
    }
    
    func request<T: Decodable>(_ urlRequest: URLRequestConvertible, completion: @escaping (Result<T, Error>) -> Void) {
        self.session
            .request(urlRequest, interceptor: self)
            .validateResponse()
            .responseDecodable(completionHandler: { (response: DataResponse<T, AFError>) in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    if let apiError = error.asAFError?.underlyingError {
                        completion(.failure(apiError))
                    } else {
                        completion(.failure(error))
                    }
                }
            })
    }
    
    func requestData(_ urlRequest: URLRequestConvertible, completion: @escaping (Result<Data, Error>) -> Void) {
        self.session.request(urlRequest, interceptor: self).validateResponse().response { (response) in
            switch response.result {
            case .success(let data):
                if let unwrapperData = data {
                    completion(.success(unwrapperData))
                } else {
                    completion(.failure(RequestError.missingData))
                }
            case .failure(let error):
                if let apiError = error.asAFError?.underlyingError {
                    completion(.failure(apiError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func request(_ urlRequest: URLRequestConvertible, completion: @escaping (Result<Void, Error>) -> Void) {
        self.session.request(urlRequest, interceptor: self).validateResponse().response { (response) in
            switch response.result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                if let apiError = error.asAFError?.underlyingError {
                    completion(.failure(apiError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < self.retrylimit else {
            // If we've hit the retry limit, don't retry anymore
            print("Retry limit reached. Not retrying.")
            completion(.doNotRetry)
            return
        }
        
        print("\nRetrying request. Retry count: \(request.retryCount)\n")
        
        // Check for specific error conditions, like timeouts, and decide to retry
        if let urlError = error as? URLError, urlError.code == .timedOut {
            // Retry with delay for timeout error
            completion(.retryWithDelay(2.0)) // Retry after 2 seconds delay
        } else {
            // If the error is not a timeout, decide whether or not to retry
            completion(.doNotRetry) // Or use .retry if you want to retry for other errors
        }
    }
}

extension DataRequest {
    func validateResponse() -> Self {
        return self.validate { _, response, data in
            let statusCode = response.statusCode
            
            switch statusCode {
            case 200...299:
                return .success(())
            default:
                return .failure(RequestManager.RequestError.requestError)
            }
        }
    }
}
