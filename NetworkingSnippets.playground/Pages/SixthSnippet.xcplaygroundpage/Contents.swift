import UIKit

struct User: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

enum GFError: String, Error {
    case serverError = "There is a problem with server"
    case decodingError = "There is a problem with decoding"
}

var users = [User]()

func fetchData(completion: @escaping(Result<[User],GFError>) -> Void) {
    let api = "https://jsonplaceholder.typicode.com/posts"
    guard let url = URL(string: api) else {fatalError()}
    let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data, error == nil else {
            completion(.failure(.serverError))
            return
        }
        do {
            let decoder = JSONDecoder()
            let users = try decoder.decode([User].self, from: data)
            completion(.success(users))
        } catch {
            completion(.failure(.decodingError))
        }
    }
    session.resume()
}


fetchData { result in
    switch result {
    case .failure(.decodingError):
        print(GFError.decodingError)
    case .failure(.serverError):
        print(GFError.serverError)
    case .success(let Users):
        users.append(contentsOf: Users)
        print(users)
    }
}
