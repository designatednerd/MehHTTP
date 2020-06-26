import MehHTTP
import PlaygroundSupport
import Foundation

/*
 # MehHTTPClient
 
 To fire off any request, create a `URLRequest` and pass it in to the `run` method.
 */

let url = HTTPBinAPI.Endpoint.get.toURL
let request = URLRequest(url: url)

MehHTTPClient.run(request: request) { result in
    switch result {
    case .success(let data):
        parseData(data)
    case .failure(let error):
        print("Network errror: \(error)")
    }
    
    PlaygroundPage.current.finishExecution()
}

//: This line tells the playground to keep executing until explicitly finished, allowing async calls to complete.
PlaygroundPage.current.needsIndefiniteExecution = true

//: And let's just hide some parsing stuff down here at the bottom

func parseData(_ data: Data) {
    print("Raw Data: \(String(data: data, encoding: .utf8) ?? "")")
    do {
        let info = try HTTPBinResponse(data: data)
        print("User agent: \(info.headers["User-Agent"] ?? "(none)")")
    } catch {
        print("Error parsing: \(error)")
    }
}
