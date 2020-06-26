import Foundation

public enum HTTPBinAPI {
  static let baseURL = URL(string: "https://httpbin.org")!
  public enum Endpoint {
    case bytes(count: Int)
    case get
    case getWithIndex(index: Int)
    case headers
    case image
    case post
    
    var toString: String {
      
      switch self {
      case .bytes(let count):
        return "bytes/\(count)"
      case .get,
           .getWithIndex:
        return "get"
      case .headers:
        return "headers"
      case .image:
        return "image/jpeg"
      case .post:
        return "post"
      }
    }
    
    var queryParams: [URLQueryItem]? {
      switch self {
      case .getWithIndex(let index):
        return [URLQueryItem(name: "index", value: "\(index)")]
      default:
        return nil
      }
    }
    
    public var toURL: URL {
      var components = URLComponents(url: HTTPBinAPI.baseURL, resolvingAgainstBaseURL: false)!
      components.path = "/\(self.toString)"
      components.queryItems = self.queryParams
      
      return components.url!
    }
  }
}

public struct HTTPBinResponse: Codable {
  
  public let headers: [String: String]
  public let url: String
  public let json: [String: String]?
  public let args: [String: String]?
  
  public init(data: Data) throws {
    self = try JSONDecoder().decode(Self.self, from: data)
  }
}
