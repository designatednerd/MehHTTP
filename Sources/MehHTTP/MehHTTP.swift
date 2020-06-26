import Foundation

public struct MehHTTPClient {
    
    public enum MehError: Error {
        case invalidResponseType(response: URLResponse?, data: Data?, underlyingError: Error?)
        case invalidStatusCode(statusCode: Int, response: HTTPURLResponse, data: Data?, underlyingError: Error?)
        case nilDataAndNoError(response: HTTPURLResponse)
    }
    
    public static func run(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            func fireCompletionOnMain(with result: Result<Data, Error>) {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                fireCompletionOnMain(with: .failure(MehError
                    .invalidResponseType(response: response,
                                         data: data,
                                         underlyingError: error)))
                return
            }
            
            guard httpResponse.isValidResponse else {
                fireCompletionOnMain(with: .failure(MehError
                    .invalidStatusCode(statusCode: httpResponse.statusCode,
                                       response: httpResponse,
                                       data: data,
                                       underlyingError: error)))
                return
            }
            
            if let urlSessionError = error {
                fireCompletionOnMain(with: .failure(urlSessionError))
                return
            }
            
            guard let data = data else {
                fireCompletionOnMain(with: .failure(MehError
                    .nilDataAndNoError(response: httpResponse)))
                return
            }
            
            fireCompletionOnMain(with: .success(data))
        }
        
        task.resume()
        
        return task
    }
    
}

extension HTTPURLResponse {
    
    var isValidResponse: Bool {
        (200..<300).contains(self.statusCode)
    }
}
