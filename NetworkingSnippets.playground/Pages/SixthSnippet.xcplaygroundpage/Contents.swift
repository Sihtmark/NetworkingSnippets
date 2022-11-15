import UIKit

struct asdf: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

enum GFError: String, Error {
    case serverError = "There is a problem with server"
    case decodingError = "There is a problem with decoding"
}

var fdsa = [asdf]()

func fetchData(completion: @escaping(Result<[asdf],GFError>) -> Void) {
    let api = "https://jsonplaceholder.typicode.com/posts"
    guard let url = URL(string: api) else {fatalError()}
    let session = URLSession(configuration: .default)
    session.dataTask(with: url) { (data, response, error) in
        DispatchQueue.main.async {
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            do {
                let decoder = JSONDecoder()
                let profiles = try decoder.decode([asdf].self, from: data)
                completion(.success(profiles))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }.resume()
}

fetchData { result in
    switch result {
    case .failure(.decodingError): print(GFError.decodingError)
    case .failure(.serverError): print(GFError.serverError)
    case .success(<#T##[asdf]#>): fdsa.append(<#T##newElement: asdf##asdf#>)
    }
}

for i in fdsa {
    print(i)
}
