import Foundation

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("Status code not in correct range in \(#function): status - \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("Network error in \(#function): \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.responseError(error)))
            } else {
                print("Other problems in \(#function)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decoder = SnakeCaseJSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    fulfillCompletionOnTheMainThread(.success(result))
                } catch {
                    print("Decode error in \(#function): \(error.localizedDescription), Response: \(String(data: data, encoding: .utf8) ?? "")")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                print("Error in \(#function): \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(error))
            }
        }
        task.resume()
        return task
    }
}
