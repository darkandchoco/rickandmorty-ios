import Alamofire
import Foundation

final class NetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "com.example.networklogger") // Serial queue for logging
    
    func requestDidResume(_ request: Request) {
        print("\n--- Request Started ---")
        print("URL: \(request.request?.url?.absoluteString ?? "No URL")")
        print("Method: \(request.request?.httpMethod ?? "No HTTP Method")")
        print("Headers: \(request.request?.allHTTPHeaderFields ?? [:])")
        if let body = request.request?.httpBody {
            print("Body: \(String(data: body, encoding: .utf8) ?? "Unable to decode body")")
        }
        print("-----------------------\n")
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("\n--- Response Received ---")
        print("URL: \(request.request?.url?.absoluteString ?? "No URL")")
        print("Status Code: \(response.response?.statusCode ?? 0)")
        print("Headers: \(response.response?.allHeaderFields ?? [:])")
        if let data = response.data {
            print("Response Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode response data")")
        }
        if let error = response.error {
            print("Error: \(error.localizedDescription)")
        }
        print("--------------------------\n")
    }
}
