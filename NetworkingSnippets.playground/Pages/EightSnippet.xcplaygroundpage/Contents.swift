import UIKit

enum GFError: Error {
    case APIError
    case responseError
    case dataError
    case decodingError
}

struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
    
    enum codingKeys: String, CodingKey {
        case userId
        case id
        case title = "task"
        case completed
    }
}

var todos = [Todo]()

func fetchTodos(completion: @escaping (Result<[Todo], GFError>) -> Void) {
    
    let api = "https://jsonplaceholder.typicode.com/todos"
    
    guard let url = URL(string: api) else {
        completion(.failure(.APIError))
        return
    }
    
    let session = URLSession.shared.dataTask(with: url) { data, response, error in
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            completion(.failure(.responseError))
            return
        }
        
        guard let data = data, error == nil else {
            completion(.failure(.dataError))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let todos = try decoder.decode([Todo].self, from: data)
            completion(.success(todos))
        } catch {
            completion(.failure(.decodingError))
        }
    }
    session.resume()
}

fetchTodos { result in
    switch result {
    case .success(let Todos):
        todos.append(contentsOf: Todos)
        print(todos)
    case .failure(.APIError):
        print("API error")
    case .failure(.responseError):
        print("Response error")
    case .failure(.dataError):
        print("Data error")
    case .failure(.decodingError):
        print("Decoding error")
    }
}
