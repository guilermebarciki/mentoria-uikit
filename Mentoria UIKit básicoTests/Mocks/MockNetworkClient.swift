import Foundation

@testable import MentoriaUIKitbasico

class MockNetworkClient: NetworkClientProtocol {
    var result: Result<Decodable, Error>?
    var lastFetchedURL: String?
    
    func fetch<T: Decodable>(from urlString: String, decodeTo type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        lastFetchedURL = urlString
        
        if let result = result {
            switch result {
            case .success(let decodable):
                if let value = decodable as? T {
                    completion(.success(value))
                } else {
                    completion(.failure(NSError(domain: "MockError", code: 422, userInfo: [NSLocalizedDescriptionKey: "Type mismatch"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        } else {
            completion(.failure(NSError(domain: "MockError", code: 500, userInfo: [NSLocalizedDescriptionKey: "No result set on mock"])))
        }
    }
}
