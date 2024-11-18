import Foundation
import Alamofire

enum RickAndMortyRouter: URLRequestConvertible {
    case getCharacters(page: Int?)
    
    private var baseURLString: String {
        return "https://rickandmortyapi.com/api"
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getCharacters: return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getCharacters:
            return "/character"
        }
    }
        
    func asURLRequest() throws -> URLRequest {
        let url = try self.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .getCharacters(let page):
            if let page = page {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: ["page": page])
            }
        }
        return urlRequest
    }
}
