import UIKit
import Foundation

enum AccountType: String, Codable {
    case Banking
    case CreditCard
    case Investment
}

enum NetworkError: Error {
    case serverError
    case decodingError
}

struct Account: Codable {
    let id: String
    let type: AccountType
    let name: String
    let amount: Decimal
    let createdDateTime: Date
}

func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account],NetworkError>) -> Void) {
    let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)/accounts")!

    URLSession.shared.dataTask(with: url) { data, response, error in
        DispatchQueue.main.async {
            guard let data = data, error == nil else {
                completion(.failure(.serverError))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let accounts = try decoder.decode([Account].self, from: data)
                completion(.success(accounts))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }.resume()
}
