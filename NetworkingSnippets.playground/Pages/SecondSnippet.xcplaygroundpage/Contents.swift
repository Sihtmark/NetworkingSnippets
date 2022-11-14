import Foundation
import UIKit

var profiles1 = [Profile]()

enum NetworkError: Error {
    case serverError
    case decodingError
}

struct Profile: Codable {
    let UserID: Int
    let id: Int
    let title: String
}

func fetchProfiles(completion: @escaping (Result<[Profile], NetworkError>) -> Void) {
    let url = URL(string: "https://jsonplaceholder.typicode.com/albums")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        DispatchQueue.main.async {
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }
            do {
                let decoder = JSONDecoder()
                let profiles = try decoder.decode([Profile].self, from: data)
                completion(.success(profiles))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }.resume()
}
